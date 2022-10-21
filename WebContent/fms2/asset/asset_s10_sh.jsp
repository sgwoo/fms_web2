<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "13", "01");
	
	String s_kd 	= request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"L":request.getParameter("gubun2");
	
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int year= 2021;// 
		
	int s_year = request.getParameter("s_year")==null?2021:Integer.parseInt(request.getParameter("s_year"));	
	
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
	//�˻��ϱ�
	function Search(){
		var fm = document.form1;	
			
		fm.action = 'asset_s10_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	
   function Search1(){
	var fm = document.form1;	
		
	fm.action = 'asset_s10_sc1.jsp';
	fm.target='c_foot';
	fm.submit();
  }

	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	
	//5����� �ڻ� ó�� ���� �۾�  
	function save(work_st, cnt)
	{
		
		var fm = document.form1;
		var SUBWIN="asset10_reg.jsp?cnt="+cnt+ "&user_id="+fm.user_id.value+"&auth_rw="+fm.auth_rw.value;	
		window.open(SUBWIN, "asset_reg", "left=50, top=50, width=500, height=400, resizable=yes, scrollbars=yes, status=yes");
	}
	
//-->
</script>
</head>
<body leftmargin="15" >
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='work_st' value=''>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > �ڻ���� > <span class=style5>
					�ڻ�_5����� </span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>

  <tr> 
     <td width="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_yd.gif" align=absmiddle >&nbsp;
              <select name="gubun1">
              	
                <%for(int i=2016; i<=year; i++){%>
                <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>��</option>
                <%}%>
              </select>
              
                <select name="gubun2">
                 <option value="1" <%if(gubun2.equals("1") ) {%>selected<%}%>>����</option>
                 <option value="2" <%if(gubun2.equals("2") ) {%>selected<%}%>>��Ʈ</option>
          
              </select>
                            
		&nbsp;<select name="gubun">
			<option value="car_no" 		<%if(gubun.equals("car_no"))%> 		selected<%%>>������ȣ</option>
			<option value="get_date" 		<%if(gubun.equals("get_date"))%> 		selected<%%>>�������</option> 
			<option value="asset_code" 		<%if(gubun.equals("asset_code"))%> 		selected<%%>>�ڻ��ڵ�</option> 		
		</select>
	     <input type="text" name="gubun_nm" size="10" value="<%=gubun_nm%>" class=text onKeydown="javascript:EnterDown()">
			  &nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
				<%if( nm_db.getWorkAuthUser("������",user_id) ){%>	
			   &nbsp;&nbsp;<a href="javascript:Search1()">��1</a>
			   <% } %>		
      </td>

 </tr>
  <tr>
       <td  align="right">&nbsp;	
	<%if(nm_db.getWorkAuthUser("������",user_id)){%> 			
			<a href="javascript:save('insert_asset', '2')">5���ڻ� ó��</a>&nbsp;&nbsp;
			
	<% } %>		
		 </td>
    </tr>
    </table>
</form> 

</body>
</html>

