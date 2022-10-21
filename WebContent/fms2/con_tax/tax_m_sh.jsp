<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'tax_m_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function cng_dt_input(){
		var fm = document.form1;
		
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '1'){ 			//년도별
			tr_dt1.style.display		= '';
			tr_dt2.style.display		= 'none';
			tr_dt3.style.display	 	= 'none';
			tr_dt4.style.display 		= 'none';		
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '2'){ 			//분기별
			tr_dt1.style.display		= '';
			tr_dt2.style.display		= '';
			tr_dt3.style.display	 	= 'none';
			tr_dt4.style.display 		= 'none';		
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ 			//월별
			tr_dt1.style.display		= '';
			tr_dt2.style.display		= 'none';
			tr_dt3.style.display	 	= '';
			tr_dt4.style.display 		= 'none';		
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ 			//기간
			tr_dt1.style.display		= 'none';
			tr_dt2.style.display		= 'none';
			tr_dt3.style.display	 	= 'none';
			tr_dt4.style.display 		= '';		
		}				
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 영업비용관리 > <span class=style5>
						개별소비세</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	
    <tr>
      <td class=line2></td>
    </tr>	
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td class="title">조회일자</td>
                <td colspan="3">
				  <table border="0" cellspacing="1" cellpadding='0'>
                    <tr>
				  	  <td width='100'>&nbsp;
				  	    <select name='gubun1'>
                  	      <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>사유발생일</option>
                  	      <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>납부일자</option>
                  	      <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>회계처리일</option>						  
                  	    </select>	</td>
				  	  <td width='100'>&nbsp;	
				  	    <select name='gubun2' onChange='javascript:cng_dt_input()'>
                  	      <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>년도별</option>
                  	      <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>분기별</option>
                  	      <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>월별</option>										
                  	      <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>기간</option>					
                  	    </select></td>
				  	  <td width='100' id=tr_dt1 style="display:<%if(!gubun2.equals("4")){%>''<%}else{%>none<%}%>">&nbsp;	
					  	<select name="gubun5" >
        			  	  <option value=""  <%if(gubun5.equals("")){%> selected <%}%>>전체</option>						
          				  <% for(int i=2002; i<=AddUtil.getDate2(1); i++){%>
          				  <option value="<%=i%>" <%if(i == AddUtil.parseInt(gubun5)){%> selected <%}%>><%=i%>년도</option>
         				  <%}%>
        				</select></td>
				  	  <td width='100' id=tr_dt2 style="display:<%if(gubun2.equals("2")){%>''<%}else{%>none<%}%>">&nbsp;	
					  	<select name="gubun6">
        			  	  <option value=""  <%if(gubun6.equals("")){%> selected <%}%>>전체</option>
        			  	  <option value="1" <%if(gubun6.equals("1")){%> selected <%}%>>1분기</option>
        			  	  <option value="2" <%if(gubun6.equals("2")){%> selected <%}%>>2분기</option>
        			  	  <option value="3" <%if(gubun6.equals("3")){%> selected <%}%>>3분기</option>
        			  	  <option value="4" <%if(gubun6.equals("4")){%> selected <%}%>>4분기</option>
        			  	</select></td>
				  	 <td width='100' id=tr_dt3 style="display:<%if(gubun2.equals("3")){%>''<%}else{%>none<%}%>">&nbsp;	
					  	<select name="gubun7">
        			  	  <option value="" <%if(gubun3.equals("")){%> selected <%}%>>전체</option>        
        			  	  <% for(int i=1; i<=12; i++){%>        
        			  	  <option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(gubun7)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
        			  	  <%}%>
        			  	</select></td>
				  	  <td width='200' id=tr_dt4 style="display:<%if(gubun2.equals("4")){%>''<%}else{%>none<%}%>">&nbsp;
                  	      <input type="text" name="st_dt" size="11" value="<%=st_dt%>" class="text">
						    ~
						  <input type="text" name="end_dt" size="11" value="<%=end_dt%>" class="text"></td>
				    </tr>
				  </table>
				</td>
              </tr>
			  <tr>
                <td width="10%" class="title">사유구분</td>
                <td width="40%">&nbsp;
					<input type="radio" name="gubun3" value=""  <%if(gubun3.equals(""))%>checked<%%>>
            		전체
            		<input type="radio" name="gubun3" value="1" <%if(gubun3.equals("1"))%>checked<%%>>
            		장기대여
            		<input type="radio" name="gubun3" value="3" <%if(gubun3.equals("3"))%>checked<%%>>
            		용도변경
            		<input type="radio" name="gubun3" value="2" <%if(gubun3.equals("2"))%>checked<%%>>
            		매각
            		<input type="radio" name="gubun3" value="4" <%if(gubun3.equals("4"))%>checked<%%>>
            		폐차
				</td>			  
			    <td width="10%" class="title">납부구분</td>
				<td >&nbsp;
					<input type="radio" name="gubun4" value=""  <%if(gubun4.equals(""))%>checked<%%>>
            		전체
            		<input type="radio" name="gubun4" value="1" <%if(gubun4.equals("1"))%>checked<%%>>
            		미납
            		<input type="radio" name="gubun4" value="2" <%if(gubun4.equals("2"))%>checked<%%>>
            		납부
				</td>
			  </tr>					  			  
              <tr>
                <td width="10%" class="title">검색조건</td>
                <td width="40%">&nbsp;
                  <select name='s_kd'>
                    <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호/성명</option>
                    <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>계약번호</option>
                    <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>차량번호</option>
					<option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>차대번호</option>
                    <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>차종</option>				
                  </select>
					&nbsp;&nbsp;&nbsp;
					<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></td>
                <td width="10%" class="title">정렬조건</td>
                <td width="40%">&nbsp;
                  <select name='sort'>
                        <option value='1' <%if(sort.equals("1")){%> selected <%}%>>상호</option>
                        <option value='2' <%if(sort.equals("2")){%> selected <%}%>>차량번호</option>
                        <option value='3' <%if(sort.equals("3")){%> selected <%}%>>차대번호</option>						
	                    <option value='4' <%if(sort.equals("4")){%> selected <%}%>>개별소비세</option>						   
                        <option value='5' <%if(sort.equals("5")){%> selected <%}%>>사유발생일</option>	
                        <option value='6' <%if(sort.equals("6")){%> selected <%}%>>지출일자</option>											
                      </select>
					&nbsp;&nbsp;&nbsp;
					<input type='radio' name='asc' value='0' <%if(asc.equals("0")){%> checked <%}%> onClick='javascript:search()'>
                      오름차순 
                      <input type='radio' name='asc' value='1' <%if(asc.equals("1")){%> checked <%}%>onClick='javascript:search()'>
                      내림차순 
					  </td>					

              </tr>
            </table></td>
    </tr>
    <tr align="right">
        <td colspan="2"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>	 
</table>
</form>
</body>
</html>

