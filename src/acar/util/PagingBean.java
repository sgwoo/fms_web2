/* paging */

package acar.util;


public class PagingBean {
	/*
	 * ���� ������
	 * */
	private int nowPage;
	/*
	 * ���� ù��° row�� �ѹ�
	 * */
	private int startNum;
	/*
	 * �Խ��� �� ������
	 * */
	private int totalCount;
	/*
	 * 1 �������� ������ ����Ʈ ����
	 * */
	private int countPerPage;
	/*
	 * paging page ������ ��� ī��Ʈ
	 * */
	private int blockCount;
	/*
	 * �˻� �÷�
	 * */
	private String searchColumn;
	/*
	 * �˻���
	 * */
	private String searchWord;
	public int getNowPage() {
		return nowPage;
	}
	public void setNowPage(int nowPage) {
		this.nowPage = nowPage;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public int getCountPerPage() {
		return countPerPage;
	}
	public void setCountPerPage(int countPerPage) {
		this.countPerPage = countPerPage;
	}
	public int getBlockCount() {
		return blockCount;
	}
	public void setBlockCount(int blockCount) {
		this.blockCount = blockCount;
	}
	public String getSearchColumn() {
		return searchColumn;
	}
	public void setSearchColumn(String searchColumn) {
		this.searchColumn = searchColumn;
	}
	public String getSearchWord() {
		return searchWord;
	}
	public void setSearchWord(String searchWord) {
		this.searchWord = searchWord;
	}
	public int getStartNum() {
		return startNum;
	}
	public void setStartNum(int startNum) {
		this.startNum = startNum;
	}
	
	
}
