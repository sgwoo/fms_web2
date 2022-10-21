<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.inside_bank.*"%>
<%@ page import="acar.bill_mng.*, acar.common.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
		
	String dt = request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String chk 	= request.getParameter("chk")==null? "":request.getParameter("chk"); //c:cash
	
	String ven_code 	= request.getParameter("ven_code")==null? "":request.getParameter("ven_code");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
   
	String hidden_value = "";
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈

	hidden_value = "?chk="+chk+"&height="+height+"&auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&dt="+dt+"&ref_dt1="+ref_dt1+"&ref_dt2="+ref_dt2+"&asc="+asc;	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.height_td {height:33px;}
select {
	width: 104px !important;
}
.input {
	height: 24px !important;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
	
		fm.submit();
	}
	
	//송금 검색하기
//	function cash(){
//		var fm =  document.form1;	
//		fm.action = 'shinhan_erp_ib_bulk.jsp';	
//		fm.target ='d_content';
//	//	fm.target = "c_foot";
//		fm.submit();
		
//	}
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
				
				
	//예금주조회결과
	function matching(){
		var fm = ii_no.document.form1;	
		
		var ccnt=	toInt(parseDigit(fm.ip_size.value));
	
		var len=fm.elements.length;
				
		var index, str;
		var cnt=0;		
		var idnum="";
					
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];	
								
			if(ck.name == "ch_cd"){	
				if(ck.checked == true){										
					cnt++;					
				}								
			}						
		}	
				
		if(cnt == 0){
			alert("데이타를 선택하세요!!!.");
			return;
		}	
				
		if(!confirm('예금주 확인처리 하시겠습니까?')){	return; }
				
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");			
								
		fm.action='./shinhan_erp_ib_bulk_a.jsp';
		fm.target='i_no';
		fm.submit();								  		
		
		link.getAttribute('href',originFunc);
					
	}				
	
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()"  style="overflow:hidden;">
<form name='form1' method='post' action='shinhan_erp_ib_bulk_c.jsp'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type='hidden' name='s_kd' value='1'>    
<input type='hidden' name='chk' > 

<table width="90%" border="0" cellspacing="0" cellpadding="0" class="search-area">

	<tr>
		<td colspan=6 style="height: 30px">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp;<span class=style1>경영정보 > 재무회계 > <span class=style5>현금지출관리</span></span></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan=6  class=h></td>
	</tr>
		
	<tr>
		<td colspan=6  class=h></td>
	</tr>	

    <tr> 
        <td width=60%><label><i class="fa fa-check-circle"></i> 출금일 </label>                     
            	 	  <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                     직전1년     
              		  <input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
                      당월 
                      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                      전월 
                      <input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>>
                      당해 
                       <input type="radio" name="dt" value="5" <%if(dt.equals("5"))%>checked<%%>>                      
                      조회기간 
                      <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
                      ~ 
                      <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" >    
         </td> 
         <!-- 
         <td colspan=2 >&nbsp;</td>
		 <td> 		    
		  <input  type="button" class="button " value="송금" onclick="javascript:cash();"> &nbsp;&nbsp; 
		 </td>  -->
         <td><!-- <label><i class="fa fa-check-circle"></i> 정렬 </label>
                <input type="radio" name="asc" value="1" <%if(asc.equals("1"))%>checked<%%>>
                      건수 
                <input type="radio" name="asc" value="2" <%if(asc.equals("2"))%>checked<%%>>
                      금액    -->
          &nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="button" value="검색" onclick="javascript:search();"> 
         </td>                       
		 <td colspan=2 >&nbsp;</td>
		 <td align=right> 		    
		 <!--  <input  id="submitLink"  type="button" class="button btn-submit" value="확인" onclick="javascript:matching();"> &nbsp;&nbsp;  -->
		 </td>
      
    </tr>
   
    <tr></tr><tr></tr><tr></tr>
  
    <tr> 
        <td colspan=9 class=line2></td>
    </tr>
         
    <tr>
		<td colspan=6>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./shinhan_erp_ib_bulk_c_s.jsp<%=hidden_value%>" name="ii_no" width="100%" height="<%=height+10%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
</body>
</html>