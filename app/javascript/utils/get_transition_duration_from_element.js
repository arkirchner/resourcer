const MILLISECONDS_MULTIPLIER = 1000;

export default function getTransitionDurationFromElement(element) {
  if (!element) {
    return 0;
  }

  // Get transition-duration of the element
  const { transitionDuration, transitionDelay } = window.getComputedStyle(element);

  const floatTransitionDuration = parseFloat(transitionDuration);
  const floatTransitionDelay = parseFloat(transitionDelay);

  // Return 0 if element or transition duration is not found
  if (!floatTransitionDuration && !floatTransitionDelay) {
    return 0;
  }

  // If multiple durations are defined, take the first
  const firstTransitionDuration = transitionDuration.split(',')[0];
  const firstTransitionDelay = transitionDelay.split(',')[0];

  return (
    (parseFloat(firstTransitionDuration) + parseFloat(firstTransitionDelay)) *
    MILLISECONDS_MULTIPLIER
  );
}
