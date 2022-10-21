package acar.insa_card;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

//게시판 페이징을 처리하는 PageMaker 클래스
public class Insa_Rc_PageMaker {
	 private int totalCount;      // 페이지 개수
	   private int startPage;      // 보이는 첫번째 페이지
	   private int endPage;      // 보이는 마지막 페이지
	   private boolean prev;      // 전페이지 이동
	   private boolean next;      // 다음페이지 이동
	   private boolean beforePrev;   // 맨처음 페이지
	   private boolean afterNext;   // 맨 마지막 페이지
	   private int displayPageNum = 10; // 화면 하단에 보여지는 페이지 버튼의 수
	   private Insa_Rc_Criteria cri;       //특정 페이지 조회를 위한 Criteria 클래스
	   
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
