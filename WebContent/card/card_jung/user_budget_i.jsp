<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function Reg()
{
	var theForm = document.ScheRegForm;
	if(theForm.user_id.value == ''){	alert("사원을 선택하십시오.");	return;	}

	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.target = "i_no";
	theForm.submit();
}

//-->
</script>
</HEAD>
<BODY>
<%

   // 2008년 매달 40000, 5월, 10월: 야유회비 :200000(40000+160000) - 2009:   2010:90만원, 2011:111만원( 빼뺴로데이 111)
   // 복지비는 매년 5만원씩 증가, 2009년 매달 43000, 5월, 10월: 야유회비 :210000(43000+167000)
   // 복지비는 매년 10만원 증가 - 2011년 적용
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String bgubun = request.getParameter("bgubun")==null?"1":request.getParameter("bgubun");
	
	//로그인ID&영업소ID
	if(user_id.equals("")) 	user_id = ck_acar_id;
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "11", "05");
	
	//해당부서 사원리스트
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = new Vector();
	if(auth_rw.equals("6")){
		users = c_db.getUserList("", "", "EMP");
	}else{
		users = c_db.getUserList_dept(user_id); 
	}
	int user_size = users.size();
	
	String dept_id = c_db.getUserDept(user_id);
%>

<table border="0" cellspacing="0" cellpadding="0" width=400 >
	<tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1> 예산관리 > <span class=style5>사용자예산등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
	<form action="./user_null_ui.jsp" name='ScheRegForm' method='post'>
	<tr>
		<td align='right' width=400>
		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	 		<a href="javascript:Reg()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a> &nbsp;
		<%}%>
			<a href="javascript:self.close();window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
		<td width=50>
		</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			
        <table border="0" cellspacing="1" cellpadding="0" width=400>
            <tr> 
              <td width=100 class='title'>사원</td>
              <td  align='left' >&nbsp; 
                <select name="user_id">
                 <option value="">선택</option>
                <!--default값으로 login 한 사용자가 선택되어있도록-->
                <%if(user_size > 0){
					for(int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i); %>
                 <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
                <%	}
				}		%>
                </select>
              </td>
              <td width=100 class='title'>항목</td>
              <td>          
              
              <select name='bgubun'>
						<option value='1' <%if(bgubun.equals("1")){%>selected<%}%>>복지비</option>
						<option value='2' <%if(bgubun.equals("2")){%>selected<%}%>>유류대</option>  
				    		
				    	</select>&nbsp;
		      </td>		    	
            <tr>
			  <td class=title>예산년도</td>
			  <td>&nbsp;<input type="text" name="byear"  size="10" class=text  ></td>	    	
              <td class=title>이월</td>
	    	<td>&nbsp;<input type="text" name="prv"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>		    
           	</tr>
           	
           	<tr>
		      <td class=title>1월</td>
		      <td>&nbsp;<input type="text" name="jan"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		      <td class=title>2월</td>
		      <td>&nbsp;<input type="text" name="feb"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
           	</tr>
           	<tr>
		      <td class=title>3월</td>
		      <td>&nbsp;<input type="text" name="mar"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		      <td class=title>4월</td>
		      <td>&nbsp;<input type="text" name="apr"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
           	</tr>    
           	<tr>
		      <td class=title>5월</td>
		      <td>&nbsp;<input type="text" name="may"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		      <td class=title>6월</td>
		      <td>&nbsp;<input type="text" name="jun"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
           	</tr>
           	<tr>
		      <td class=title>7월</td>
		      <td>&nbsp;<input type="text" name="jul"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		      <td class=title>8월</td>
		      <td>&nbsp;<input type="text" name="aug"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
           	</tr>      
           	<tr>
		      <td class=title>9월</td>
		      <td>&nbsp;<input type="text" name="sep" " size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		      <td class=title>10월</td>
		      <td>&nbsp;<input type="text" name="oct"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
           	</tr>
           	<tr>
		      <td class=title>11월</td>
		      <td>&nbsp;<input type="text" name="nov"  size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		      <td class=title>12월</td>
		      <td>&nbsp;<input type="text" name="dec" " size="10" class=text style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value); '></td>
           	</tr> 
        
        </table>
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<input type="hidden" name="acar_id" value="<%=user_id%>">
			<input type="hidden" name="dept_id" value="<%=dept_id%>">
			<input type="hidden" name="cmd" value="i">
											
		</td>
	</tr>
	
	</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
