<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_asset_s4_excel_j.xls");
%>


<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	
	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
	String chk = request.getParameter("chk")==null?"0":request.getParameter("chk");  //0:취득자산. 1:차량대금 
	
//	int alt_amt = 0;
			
	AssetDatabase as_db = AssetDatabase.getInstance();
	
	Vector vt = new Vector();
	
	if ( chk.equals("0") )  {		
		vt = as_db.getAssetGetListAll(chk1,st_dt,end_dt,s_kd);
	} else {
		vt = as_db.getAssetGetListAll1(chk1,st_dt,end_dt,s_kd);	
	}
	int cont_size = vt.size();
	
	long t_amt1[] = new long[1];  //기초가액
    long t_amt3[] = new long[1];  //충당금 증가
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
</head>
<body>

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="100%">    
                <tr>
                    <td class=line2></td>
                </tr>        	
            	<tr>
            		<td class=line>
            			<table border=0 cellspacing=1 width=100%>
                            <tr> 
                                <td width=30 class=title>연번</td>
                                <td width=100 class=title>차량번호</td>
                                <td width=80 class=title>자산코드</td>
                                <td class=title>자산명</td>
                              <!--  <td class=title>차종</td> -->
                                <td width=100 class=title>취득일</td>
                				<td width=200 class=title>내용</td>
                				<td width=120 class=title>취득액</td>
                			<!--	<td width=120 class=title>매각액</td> -->
            		        </tr>
              <%if(cont_size > 0){%>
                            <tr> 
                <%	for(int i = 0 ; i < cont_size ; i++){
            				Hashtable ht = (Hashtable)vt.elementAt(i); 
            				
            				long t1=0;
            				long t3=0;
            																		
            			    t1 = AddUtil.parseLong(String.valueOf(ht.get("CAP_AMT")));
            			    t3 = AddUtil.parseLong(String.valueOf(ht.get("SALE_AMT")));
            			    
            			    for(int j=0; j<1; j++){
            						t_amt1[j] += t1;
            						t_amt3[j] += t3;
            				}
            %>
            				              
                                <td width=30 align="center"><%=i+1%></td>
                                <td width=100 align="center"><%= ht.get("CAR_NO") %></td>
                                <td width=80 align="center"><%= ht.get("ASSET_CODE") %></td>
                                <td align="left"><%= ht.get("ASSET_NAME") %></td>
                         <!--       <td align="left"></td> -->
                			    <td width=100 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ASSCH_DATE")))%></td>
                                <td width=200 align="center"><%=ht.get("ASSCH_RMK")%></td>	
                                <td width=120 align="right"><%=Util.parseDecimal(t1)%></td>	
                          <!--      <td width=120 align="right"><%=Util.parseDecimal(t3)%></td>	-->
                            </tr>
                 <%	}%>
            	  		    <tr> 
            	                <td colspan="6"  class=title align="center">합계</td>
            	                <td width='120'  class=title style='text-align:right'><%=Util.parseDecimal(t_amt1[0])%></td>				
            	     <!--       <td width='120'  class=star align='right'><%=Util.parseDecimal(t_amt3[0])%></td>		-->	
            	            </tr>
            <%	}else{	%>    		  
                            <tr> 
                                <td colspan="8" align="center">&nbsp;등록된 데이타가 없습니다.</td>
                            </tr>
        <%}%>			  
			            </table>
		            </td>
	            </tr>	 	 
            </table>
        </td>
    </tr>
</table>

</body>
</html>


