/**
 * 
 */
package org.dita2indesign.indesign.inx.model;

import java.util.List;

import org.apache.log4j.Logger;

/**
 * A point within a path. Consists of three Point objects:
 * <ul>
 * <li>Anchor point</li>
 * <li>Left direction point</li>
 * <li>Right direction point</li>
 * </ul>
 */
public class PathPoint {

	Logger logger = Logger.getLogger(PathPoint.class);

	private Point anchorPoint = new Point(0.0,0.0);
	private Point leftDirectionPoint = new Point(0.0,0.0);
	private Point rightDirectionPoint = new Point(0.0,0.0);
	private int pointType;

	/**
	 * Construct a "corner" point.
	 * @param left
	 * @param top
	 */
	public PathPoint(Double x, Double y) {
		this.setAnchorPoint(new Point(x, y));
		// For "corner" points, the left and right direction points
		// are the same as the anchor point.
		this.setLeftDirectionPoint(new Point(x, y));
		this.setRightDirectionPoint(new Point(x, y));
	}

	/**
	 * Default constructor.
	 */
	public PathPoint() {
	}

	/**
	 * @return the x
	 */
	public double getX() {
		return this.anchorPoint.getX();
	}

	/**
	 * @return the y
	 */
	public double getY() {
		return this.anchorPoint.getY();
	}
	
	public Point getAnchorPoint() {
		return this.anchorPoint;
	}

	public Point getLeftDirectionPoint() {
		return this.leftDirectionPoint;
	}

	public Point getRightDirectionPoint() {
		return this.rightDirectionPoint;
	}

	/**
	 * @param values
	 * @param itemCursor
	 * @return
	 */
	public int loadData(List<InxValue> values, int itemCursor) {
		InxValue value = values.get(itemCursor++);
		this.pointType = ((InxLong32)value).getValue().intValue();
		double x;
		double y;
		switch (pointType) {
		case 2: // Corner point.
			x = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
			y = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
			this.setAnchorPoint(new Point(x, y));
			break;
		case 0: // Continuous point.
			x = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
			y = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
			this.setAnchorPoint(new Point(x, y));
			x = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
			y = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
			this.setLeftDirectionPoint(new Point(x, y));
			x = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
			y = ((InxDouble)values.get(itemCursor++)).getValue().doubleValue();
			this.setRightDirectionPoint(new Point(x, y));
			break;
		default:
			logger.error("Unhandled point type " + pointType);
			throw new RuntimeException("Unhandled point type " + pointType);
		}
		return itemCursor;
	}

	/**
	 * @param point
	 */
	public void setLeftDirectionPoint(Point point) {
		this.leftDirectionPoint = point;
	}

	/**
	 * @param point
	 */
	public void setRightDirectionPoint(Point point) {
		this.rightDirectionPoint = point;
	}

	/**
	 * @param point
	 */
	public void setAnchorPoint(Point point) {
		this.anchorPoint = point;		
	}
	
	public String toString() {
		StringBuilder result = new StringBuilder("[");
        result.append(this.pointType)
        .append(",")
        .append("(")
        .append(this.anchorPoint.toString())
        .append("), (")
        .append(this.leftDirectionPoint.toString())
        .append("), (")
        .append(this.rightDirectionPoint.toString())
        .append(")")
        .append("]")
        ;
        return result.toString();
	}
	
}
