# Borrowed Hands Demo

A tiny SwiftUI app that exists to be compiled by someone else.

This repository is the demo fixture for [Borrowed Hands](https://github.com/alext8900/borrowed-hands), which lets a cloud Hermes agent ask your paired Mac to compile an Xcode project inside a locked-down sandbox. The app itself is one screen: a raised hand with sparkles, the title "Built by Hermes", the line "Compiled on your Mac by Borrowed Hands", an accent picker and a high-five counter. A footer shows which platform the binary was compiled for.

## What is in here

- `BorrowedHandsDemo.xcodeproj` with one multiplatform SwiftUI app target and a shared scheme, `BorrowedHandsDemo`, that builds for macOS and the iOS Simulator.
- `BorrowedHandsDemo/` with four Swift files. No asset catalog, no images (the artwork is SF Symbols), no Swift packages and no Run Script phases.

That shape is deliberate. The Borrowed Hands runner builds with no network, signing turned off and remote Swift packages refused, so this project needs nothing beyond the files in the commit.

The code also avoids Swift macros. In the Xcode 27 SDK, `@State`, `#Preview`, `@Observable` and friends are macros, and the compiler runs macro plugins inside a sandbox of their own, which the runner's build sandbox does not allow. So the app keeps its state in `@AppStorage` and uses `PreviewProvider` for previews. If you change the code, keep it macro-free or the build fails with "external macro implementation type ... could not be found".

## Grant it on your Mac

With the Borrowed Hands helper installed and paired, grant the macOS build:

```sh
bh grant add xcode.build --workspace demo --repo https://github.com/alext8900/borrowed-hands-demo.git --project BorrowedHandsDemo.xcodeproj --scheme BorrowedHandsDemo --configuration Debug --destination 'platform=macOS,arch=arm64'
```

Then ask Hermes:

> Build my demo project on my Mac

To build for the iOS Simulator as well, add a second workspace for the same repo with the simulator destination:

```sh
bh grant add xcode.build --workspace demo-ios --repo https://github.com/alext8900/borrowed-hands-demo.git --project BorrowedHandsDemo.xcodeproj --scheme BorrowedHandsDemo --configuration Debug --destination 'generic/platform=iOS Simulator'
```

and ask Hermes to "build demo-ios on my Mac". With two grants on the Mac, a request that names neither is ambiguous, so Hermes asks which one you mean. If you want the one-line "Build my demo project on my Mac" to just go, keep a single grant. `bh grant list` shows what you have granted and `bh grant revoke demo-ios` takes one back.

## Which commit gets built

Borrowed Hands only builds commits that are reachable from a branch under `bh/`. This repository has exactly one, `bh/main`. When you ask for a build without naming a commit, Hermes builds the tip of `bh/main`.

So `bh/main` is the hand-off point: pushing to it is how you give Hermes a new version to build.

```sh
git push origin HEAD:bh/main
```

A good live demo is to push a change with a compile error, ask Hermes to build, watch it report the error with file and line, then push the fix and build again.

## Building it yourself

Open the project in Xcode and run, or compile from the command line the way the runner does:

```sh
xcodebuild -project BorrowedHandsDemo.xcodeproj -scheme BorrowedHandsDemo -configuration Debug \
  -destination 'platform=macOS,arch=arm64' CODE_SIGNING_ALLOWED=NO build
```

Use `-sdk iphonesimulator -destination 'generic/platform=iOS Simulator'` for the simulator build. The project targets macOS 15 and iOS 18 and was written for Xcode 27.

## License

MIT. See [LICENSE](LICENSE).
