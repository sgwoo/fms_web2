package acar.insa_card;

import java.util.List;

public class Insa_Rc_SearchCriteria extends Insa_Rc_Criteria{
	private String searchType="";
	   private String keyword="";
	   private List<Integer> myBoardNoList; 
	   
	   public String getSearchType() {
	      return searchType;
	   }
	   public void setSearchType(String searchType) {
	      this.searchType = searchType;
	   }
	   public String getKeyword() {
	      return keyword;
	   }
	   public void setKeyword(String keyword) {
	      this.keyword = keyword;
	   }
	   public List<Integer> getMyBoardNoList() {
	      return myBoardNoList;
	   }
	   public void setMyBoardNoList(List<Integer> myBoardNoList) {
	      this.myBoardNoList = myBoardNoList;
	   }
	   



}
