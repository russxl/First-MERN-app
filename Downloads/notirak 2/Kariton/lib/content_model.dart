class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({required this.image, required this.title, required this.description});
}

List<OnboardingContent> contents = [
  OnboardingContent(
    title: 'Segregate it!',
    image: 'assets/onboard_image.png',
    description: "Makes it more efficient to sort them "
        "out and being more responsible "
        "individual ",
  ),
  OnboardingContent(
    title: 'Recycle it!',
    image: 'assets/onboard_image2.png',
    description: "Easily collect household waste and "
        "generate less waste ",
  ),
];
