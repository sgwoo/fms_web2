package acar.insa_card;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

//�Խ��� ����¡�� ó���ϴ� PageMaker Ŭ����
public class Insa_Rc_PageMaker {
	 private int totalCount;      // ������ ����
	   private int startPage;      // ���̴� ù��° ������
	   private int endPage;      // ���̴� ������ ������
	   private boolean prev;      // �������� �̵�
	   private boolean next;      // ���������� �̵�
	   private boolean beforePrev;   // ��ó�� ������
	   private boolean afterNext;   // �� ������ ������
	   private int displayPageNum = 10; // ȭ�� �ϴܿ� �������� ������ ��ư�� ��
	   private Insa_Rc_Criteria cri;       //Ư�� ������ ��ȸ�� ���� Criteria Ŭ����
	   
	   private int totalPage;

	   public void setCri(Insa_Rc_Criteria cri) {
	      this.cri = cri;
	   }

	   public void setTotalCount(int totalCount) {
	      this.totalCount = totalCount;
	      calcData();
	   }

	   public int getTotalCount() {
	      return totalCount;
	   }

	   public int getStartPage() {
	      return startPage;
	   }

	   public int getEndPage() {
	      return endPage;
	   }

	   public boolean isPrev() {
	      return prev;
	   }

	   public boolean isNext() {
	      return next;
	   }

	   public boolean isbeforePrev() {
	      return beforePrev;
	   }

	   public boolean isafterNext() {
	      return afterNext;
	   }

	   public int getDisplayPageNum() {
	      return displayPageNum;
	   }

	   public Insa_Rc_Criteria getCri() {
	      return cri;
	   }

	   public int getTotalPage() {
	      return totalPage;
	   }
	   

	   public void setTotalPage(int totalCount) {
	      totalPage = (int) Math.ceil(totalCount /(double) cri.getPerPageNum());
	   }

	   private void calcData() {

	      endPage = (int) (Math.ceil(cri.getPage() / (double) displayPageNum) * displayPageNum);

	      startPage = (endPage - displayPageNum) + 1;
	      if (startPage <= 0) {
	         startPage = 1;
	      }

	      int tempEndPage = (int) (Math.ceil(totalCount / (double) cri.getPerPageNum()));
	      if (endPage > tempEndPage) {
	         endPage = tempEndPage;
	      }

	      prev = startPage == 1 ? false : true;

	      next = endPage * cri.getPerPageNum() < totalCount ? true : false;

	      /* beforePrev= cri.getPage()>10? true : false; */
	      
	      beforePrev= startPage>10? true : false;
	      
	      totalPage = (int) Math.ceil(totalCount /(double) cri.getPerPageNum());
	      afterNext = cri.getPage() < totalPage ? true : false;
	   }

	   /*public String makeQuery(int page) {
	      String url =new StringBuffer().queryParam("page", page)
	            .queryParam("perPageNum", cri.getPerPageNum()).build();

	      return url.toString();
	   }
	  
	   public String makeSearch(int page) {
		   String url =new StringBuffer().queryParam("page", page)
	            .queryParam("perPageNum", cri.getPerPageNum())
	            .queryParam("searchType", ((Insa_Rc_SearchCriteria) cri).getSearchType())
	            .queryParam("keyword", encoding(((Insa_Rc_SearchCriteria) cri).getKeyword())).build();

	      return url.toString();
	   }*/

	   private Object encoding(String keyword) {
	      if (keyword == null || keyword.trim().length() == 0) {
	         return "";
	      }
	      try {
	         return URLEncoder.encode(keyword, "UTF-8");
	      } catch (UnsupportedEncodingException e) {
	
	         return "";
	      }
	   }

	   @Override
	   public String toString() {
	      return "PageMaker [totalCount=" + totalCount + ", startPage=" + startPage + ", endPage=" + endPage
	            + ", totalPage=" + totalPage + ", prev=" + prev + ", next=" + next + ", beforePrev=" + beforePrev
	            + ", afterNext=" + afterNext + ", displayPageNum=" + displayPageNum + ", cri=" + cri + "]";
	   }

}
