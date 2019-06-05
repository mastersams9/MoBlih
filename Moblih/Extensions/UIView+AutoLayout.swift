import UIKit

extension UIView {
  @discardableResult
  public func prepareForAutoLayout() -> Self {
    translatesAutoresizingMaskIntoConstraints = false
    return self
  }

  public func pinToOtherView<LayoutAnchorType, Axis>(_ other: UIView,
                                                     from: KeyPath<UIView, LayoutAnchorType>,
                                                     to: KeyPath<UIView, LayoutAnchorType>,
                                                     constant: CGFloat = 0) -> NSLayoutConstraint
    where LayoutAnchorType: NSLayoutAnchor<Axis> {
    guard superview != nil
      && ((other is UIWindow) || (other.superview != nil)) else { fatalError("must addSubview first") }

    let source = self[keyPath: from]
    let target = other[keyPath: to]
    return source.constraint(equalTo: target, constant: constant)
  }

  public func pinToOtherView<LayoutAnchorType, Axis>(_ other: UIView,
                                                     from: KeyPath<UIView, LayoutAnchorType>,
                                                     constant: CGFloat = 0) -> NSLayoutConstraint
    where LayoutAnchorType: NSLayoutAnchor<Axis> {
    return pinToOtherView(other, from: from, to: from, constant: constant)
  }

  public func pinToSuperview<LayoutAnchorType, Axis>(_ from: KeyPath<UIView, LayoutAnchorType>,
                                                     to: KeyPath<UIView, LayoutAnchorType>,
                                                     constant: CGFloat = 0) -> NSLayoutConstraint
    where LayoutAnchorType: NSLayoutAnchor<Axis> {
    guard let parent = superview else { fatalError("must addSubview first") }

    let source = self[keyPath: from]
    let target = parent[keyPath: to]
    return source.constraint(equalTo: target, constant: constant)
  }

  public func pinToSuperview<LayoutAnchorType, Axis>(_ anchor: KeyPath<UIView, LayoutAnchorType>,
                                                     constant: CGFloat = 0) -> NSLayoutConstraint
    where LayoutAnchorType: NSLayoutAnchor<Axis> {
    return pinToSuperview(anchor, to: anchor, constant: constant)
  }

  public func pin(_ anchor: KeyPath<UIView, NSLayoutDimension>, constant: CGFloat) -> NSLayoutConstraint {
    return self[keyPath: anchor].constraint(equalToConstant: constant)
  }

  public func pinEdgesToSuperview() -> [NSLayoutConstraint] {
    return [
      pinToSuperview(\UIView.leadingAnchor),
      pinToSuperview(\UIView.topAnchor),
      pinToSuperview(\UIView.trailingAnchor),
      pinToSuperview(\UIView.bottomAnchor)
    ]
  }

  public func constraintToView(_ view: UIView) {
    leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    translatesAutoresizingMaskIntoConstraints = false
//    layoutIfNeeded()
  }
}

extension Array where Element == NSLayoutConstraint {
  public func activate() {
    NSLayoutConstraint.activate(self)
  }
}
