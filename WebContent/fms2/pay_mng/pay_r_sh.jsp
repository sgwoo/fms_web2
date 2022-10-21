<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();

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
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//출금항목구분
		CodeBean[] codes = c_db.getCodeAll("0044");
		int c_size = codes.length;
			
		//계정과목
		CodeBean[] accts = c_db.getCodeAll_0043();
		int a_size = accts.length;
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
		fm.action = 'pay_r_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function pop_excel(){
		var fm = document.form1;
		if(fm.gubun1.value != '3'){
			alert('기간으로 조회하십시오.'); 
			return;
		}
		if(fm.st_dt.value == '' || fm.end_dt.value == ''){
			alert('일자를 입력하십시오.'); 
			return;
		}
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'pay_r_sc_excel.jsp';
		fm.target='_blank';
		fm.submit();	
	}

	function pop_excel2(){
		var fm = document.form1;
		if(fm.gubun1.value != '3'){
			alert('기간으로 조회하십시오.'); 
			return;
		}
		if(fm.st_dt.value == '' || fm.end_dt.value == ''){
			alert('일자를 입력하십시오.'); 
			return;
		}
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'pay_r_sc_excel2.jsp';
		fm.target='_blank';
		fm.submit();	
	}	
	
	function pop_bank_acc(){
		var fm = document.form1;
		if(fm.gubun1.value != '3'){
			alert('기간으로 조회하십시오.'); 
			return;
		}
		if(fm.st_dt.value == '' || fm.end_dt.value == ''){
			alert('일자를 입력하십시오.'); 
			return;
		}
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'pay_r_sc_bank_acc.jsp';
		fm.target='_blank';
		fm.submit();	
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
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						출금송금결과</span></span></td>
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
                <td width="40%">&nbsp;
				  <select name='gubun4'>
                    <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>요청일자</option>
                    <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>송금일자</option>					
                  </select>			
				  &nbsp;	
				  <select name='gubun1'>
                    <option value="4" <%if(gubun1.equals("4"))%>selected<%%>>전일</option>
                    <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>당일</option>
                    <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>당월</option>
                    <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>기간</option>					
                  </select>		
				  &nbsp;				  
                    <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
					~
					<input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text"></td>
                <td width="10%" class="title">구분</td>
                <td width="40%">&nbsp;
                  송금구분 : 
                  <select name='gubun2'>
                    <option value="">전체</option>
                    <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>대기</option>
                    <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>송금</option>
                  </select>
                  &nbsp;&nbsp;&nbsp;&nbsp;
                  은행연동 : 
                  <select name='gubun3'>
                      	<option value="">전체</option>
                      	<option value="Y" <%if(gubun3.equals("Y"))%>selected<%%>>대상</option>
						<option value="N" <%if(gubun3.equals("N"))%>selected<%%>>비대상</option>
                  </select>
                  </td>
              </tr>
              <tr>
                <td width="10%" class="title">검색조건</td>
                <td >&nbsp;
                  <select name='s_kd'>
                    <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>지출처 </option>
                    <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>입금은행</option>
                    <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>입금계좌</option>
                    <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>출금은행</option>
                    <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>출금계좌</option>
                    <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>송금등록자</option>
                    <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>출금등록자</option>
                  </select>
					&nbsp;&nbsp;&nbsp;
					<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></td>
                <td class="title">출금항목</td>
                <td>&nbsp;
                    <select name='gubun5'>
                      	<option value="">선택</option>
						<option value="">==조회등록==</option>
						<%for(int i = 0 ; i < c_size ; i++){
       						CodeBean code = codes[i];	%>
		        		<option value='<%=code.getNm_cd()%>' <%if(code.getNm_cd().equals(gubun5)){%>selected<%}%>><%= code.getNm()%></option>
		        		<%}%>	
						<option value="">==직접등록==</option>
						<%for(int i = 0 ; i < a_size ; i++){
       						CodeBean code = accts[i];	%>
		        		<option value='<%=code.getNm_cd()%>' <%if(code.getNm_cd().equals(gubun5) && !code.getCode().equals("0000")){%>selected<%}%>><%= code.getNm()%></option>
		        		<%}%>
                  	</select>	                  
                  </td>
              </tr>
            </table></td>
    </tr>
    <tr align="right">
        <td colspan="2">
           <input type="button" class="button" value="검색" onclick="javascript:search();">                   
           <input type="button" class="button" value="Excel" onclick="javascript:pop_excel();"> 
             <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출금점검자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id)){%>
           <input type="button" class="button" value="계좌별송금현황" onclick="javascript:pop_excel2();"> 
           <input type="button" class="button" value="계좌확인일괄처리" onclick="javascript:pop_bank_acc();"> 
             <% } %>
      <!--   
        <a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>            
                &nbsp;&nbsp;&nbsp;
                <a href="javascript:pop_excel()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_excel.gif border=0 align=absmiddle></a>                        
                <%//if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출금점검자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id)){%>
                &nbsp;&nbsp;&nbsp;
                <a href="javascript:pop_excel2()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[계좌별송금현황]</a>                        
                &nbsp;&nbsp;&nbsp;
                <a href="javascript:pop_bank_acc()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[계좌확인일괄처리]</a>                        
                <%//}%> -->
        </td>
    </tr>	 
</table>
</form>
</body>
</html>

