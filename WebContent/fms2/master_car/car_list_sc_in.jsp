<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.admin.*" %>	
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");	

	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	Vector vt = ad_db.getMasterCarComAcarExcelList(s_kd, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}
	

//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width="3500">
 <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='12%' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%' height=71>       
          <tr> 
        	<td class="title" width='12%'>연번</td>
			<td class="title" width='10%'>구분</td>	  
			<td class="title" width='16%'>등록일자</td>	  	  
			<td class="title" width='20%'>차량번호</td>
			<td class="title" width='42%'>차종</td>
          </tr>
      </table>
	</td>
	<td class='line' width='88%'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%' height=71>    
		<tr>
		  <td class="title" width='3%'>제조사</td>
		  <td class="title" width='2%'>연식</td>			
		  <td class="title" width='2%'>미션</td>				  
		  <td class="title" width='4%'>연료</td>
		  <td class="title" width='6%'>고객</td>
		  <td class="title" width='4%'>사무실</td>
		  <td class="title" width='4%'>휴대폰</td>			 		
		  <td class="title" width='14%'>주소</td>
		   <td class="title" width='4%'>실운전자</td>		
	<!--	  <td class="title" width='5%'>이메일</td> -->
		  <td class="title" width='3%' >보험사</td>
		  <td class="title" width='4%'>대여기간</td>			
		  <td class="title" width='5%'>대인배상Ⅰ</td>
		  <td class="title" width='3%'>대인배상Ⅱ</td>
		  <td class="title" width='3%'>대물배상</td>
		  <td class="title" width='3%'>자기신체사고<br>_사망장애</td>			
		  <td class="title" width='3%'>자기신체사고<br>_부상</td>
		  <td class="title" width='3%'>자차차량</td>
		  <td class="title" width='3%'>자차자기부담금</td>
		  <td class="title" width='2%'>무보험</td>			
		  <td class="title" width='2%'>보험종류</td>
		  <td class="title" width='3%'>연령범위</td>			
		  <td class="title" width='2%'>에어백</td>
		  <td class="title" width='4%'>피보험자</td>
		  <td class="title" width='2%'>최초<br>등록일</td>		
		  <td class="title" width='2%'>등록지역</td>		
		  <td class="title" width='2%'>대여방식</td>			
		  <td class="title" width='2%'>관리<br>담당자</td>			
		  <td class="title" width='3%'>연락처</td>	
		  <td class="title" width='2%'>검사의뢰</td>			  	  	  	  	     
		</tr>
	  </table>
	</td>
  </tr>

 <%if(vt_size > 0){%>
  <tr>		
    <td class='line' width='12%' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>
        <tr > 
         <td align="center" width='12%'><%=i+1%></td>
		  <td align="center" width='10%'><%=ht.get("구분")%></td>	  
		  <td align="center" width='16%'><%=ht.get("등록일자")%></td>	  	  
		  <td align="center" width='20%'><%=ht.get("차량번호")%></td>
		  <td align="center" width='42%'>
		  <span title='<%=ht.get("차종")%>'><%=Util.subData(String.valueOf(ht.get("차종")),10)%></span></td>
		 
        </tr>      
        <%		}	%>
       	
      </table>
	</td>
	<td class='line' width='88%'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		<tr>
		  <td align="center"	width='3%'><%=ht.get("제조사")%></td>
		  <td align="center"	width='2%'><%=ht.get("연식")%></td>
		  <td align="center"	width='2%'><%=ht.get("미션")%></td>	  
		  <td align="center"	width='4%'><%=ht.get("연료")%></td>
		  <td align="center"	width='6%'>
		   <span title='<%=ht.get("고객")%>'><%=Util.subData(String.valueOf(ht.get("고객")),14)%></span></td>
		  <td align="center"	width='4%'><%=ht.get("사무실")%></td>
		  <td align="center"	width='4%'><%=ht.get("휴대폰")%></td>				  
		  <td align="center"	width='14%'>
		   <span title='<%=ht.get("주소")%>'><%=Util.subData(String.valueOf(ht.get("주소")),30)%></span></td>	
		  <td align="center"	width='4%'><%=ht.get("실운전자")%></td>	
	<!--	  <td align="center"	width='5%'><%=ht.get("이메일")%></td> -->
		  <td align="center"	width='3%'><%=ht.get("보험사")%></td>
		  <td align="center"	width='4%'><%=ht.get("대여기간")%></td>
		  <td align="center"	width='5%'><%=ht.get("대인배상Ⅰ")%></td>
		  <td align="center"	width='3%'><%=ht.get("대인배상Ⅱ")%></td>
		  <td align="center"	width='3%'><%=ht.get("대물배상")%></td>
		  <td align="center"	width='3%'><%=ht.get("자기신체사고_사망장애")%></td>
		  <td align="center"	width='3%'><%=ht.get("자기신체사고_부상")%></td>
		  <td align="center"	width='3%'><%=ht.get("자차차량")%></td>
		  <td align="center"	width='3%'><%=ht.get("자차자기부담금")%></td>
		  <td align="center"	width='2%'><%=ht.get("무보험")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("보험종류")%></td>
		  <td align="center"	width='3%'><%=ht.get("연령범위")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("에어백")%></td>
		  <td align="center"	width='4%'><%=ht.get("피보험자")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("최초등록일")%></td>
		  <td align="center"	width='2%'><%=ht.get("등록지역")%></td>
		  <td align="center"	width='2%'><%=ht.get("대여방식")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("관리담당자")%></td>
		  <td align="center"	width='3%'><%=ht.get("연락처")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("요청")%></td>	  
		</tr>
	
<%	}	%>
		
	  </table>
	</td>
 </tr>
 <%	}else{%>                     
  <tr>
	  <td class='line' width='12%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='88%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
</table>

</body>
</html>
