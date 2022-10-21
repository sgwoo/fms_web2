<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	
	
	String gubun 		= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String res_yn 		= request.getParameter("res_yn")	==null?"":request.getParameter("res_yn");
	String res_mon_yn	= request.getParameter("res_mon_yn")	==null?"":request.getParameter("res_mon_yn");
	String all_car_yn	= request.getParameter("all_car_yn")	==null?"":request.getParameter("all_car_yn");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	auth_rw = rs_db.getAuthRw(user_id, "06", "01", "04");
%>
<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') ybSearch();
}
function ybSearch()
{
	var theForm = document.Offls_ybSearchForm;
	
	if(theForm.all_car_yn.checked == true) theForm.res_mon_yn.checked = false;
		
	theForm.target = "c_body";
	theForm.submit();
}

function cancelSecondhand(){
	var fm = parent.c_body.inner.form1;
	var len = fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		if(ck.name == 'pr'){
			if(ck.checked == true){
				cnt++;
				idnum = ck.value;			
			}
		}
	}
	if(cnt == 0){ alert("������ �����ϼ��� !"); return; }
	if(!confirm('������ ���� �縮���� ��� �Ͻðڽ��ϱ�?')){	return;	}
	fm.action = "cancelSecondhand.jsp";
	fm.target = "i_no";
	fm.submit();
}
//-->
</script>
</head>
<body>
<form name='Offls_ybSearchForm' method='post' action='secondhand_sc.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
    	<td>
    		<table width=100% border=0 cellpadding=0 cellspacing=0>
        		<tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ����������Ȳ > <span class=style5>�縮������������Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
      		</table>
    	</td>
  	</tr>
  	<tr>
	  <td class=h></td>
  	</tr>
  	<tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǰ˻�</span></td>
  	</tr>
  	<tr>
    	<td class=line2></td>
  	</tr>
  	<tr>
    	<td class=line>
	    	<table border="0" cellspacing="1" cellpadding='0' width=100%>
        		<tr>
          			<td class="title" width=10%>����</td>
          			<td width="40%">&nbsp;
          				<select name="gubun2" style="width: 150px;">
							<option value=""  <% if(gubun2.equals("")) out.print("selected"); %>>��ü</option>
							<option value="8" <% if(gubun2.equals("8")) out.print("selected"); %>>�����¿�(LPG)</option>		  
							<option value="5" <% if(gubun2.equals("5")) out.print("selected"); %>>�����¿�(LPG)</option>
							<option value="4" <% if(gubun2.equals("4")) out.print("selected"); %>>�����¿�(LPG)</option>
							<option value="3" <% if(gubun2.equals("3")) out.print("selected"); %>>�����¿�(���ָ�,����)</option>
							<option value="2" <% if(gubun2.equals("2")) out.print("selected"); %>>�����¿�(���ָ�,����)</option>
							<option value="1" <% if(gubun2.equals("1")) out.print("selected"); %>>�����¿�(���ָ�)</option>
							<option value="6" <% if(gubun2.equals("6")) out.print("selected"); %>>RV�ױ�Ÿ</option>																  		
							<option value="7" <% if(gubun2.equals("7")) out.print("selected"); %>>������</option>
						</select>
						&nbsp;<input type="checkbox" name="res_yn" value="Y" <% if(res_yn.equals("Y")) out.print("checked"); %>> ���������	
						<select name='res_mon_yn'>
		  					<option value=''>����</option>
                  			<option value='Y' <%if(res_mon_yn.equals("Y")){%>selected<%}%>>����Ʈ��ü</option>              
                  			<option value='Y2' <%if(res_mon_yn.equals("Y2")){%>selected<%}%>>����Ʈ(���Ό��5���̻�����)</option>                  
                		</select>
						<!--&nbsp;<input type="checkbox" name="res_mon_yn" value="Y" <% if(res_mon_yn.equals("Y")) out.print("checked"); %>> ����Ʈ-->
						&nbsp;<input type="checkbox" name="all_car_yn" value="Y" <% if(all_car_yn.equals("Y")) out.print("checked"); %>> ��ü	
		      		</td>
		          	<td class=title width=10%>������ �����˻�</td>
		          	<td width=40%>&nbsp;
						<select name='brch_id' style="width: 150px;">
		  					<option value=''>��ü</option>
                  			<option value='S1' <%if(brch_id.equals("S1")){%>selected<%}%>>����</option>              
							<option value='B1' <%if(brch_id.equals("B1")){%>selected<%}%>>�λ�</option>
							<option value='D1' <%if(brch_id.equals("D1")){%>selected<%}%>>����</option>
							<option value='J1' <%if(brch_id.equals("J1")){%>selected<%}%>>����</option>
							<option value='G1' <%if(brch_id.equals("G1")){%>selected<%}%>>�뱸</option>
                		</select>
		        	</td>
        		</tr>
			    <tr>
			       	<td class=title width=10%>�˻�����</td>
			       	<td width=40%>&nbsp;
			       		<select name='gubun' style="width: 150px;">
						 	<option value='all' >��ü</option>
							<option value='car_no' 	<%if(gubun.equals("car_no")){%>selected<%}%>>������ȣ</option>
							<option value='jg_code' 	<%if(gubun.equals("jg_code")){%>selected<%}%>>�����ڵ�</option>
							<option value='car_nm' 	<%if(gubun.equals("car_nm")){%>selected<%}%>>����</option>
							<option value='situ_nm' 	<%if(gubun.equals("situ_nm")){%>selected<%}%>>������</option>
							<option value='init_reg_dt' 	<%if(gubun.equals("init_reg_dt")){%>selected<%}%>>���ʵ����</option>
							<option value='park' 		<%if(gubun.equals("park")){%>selected<%}%>>����ġ/����������</option>
							<option value='park_condition' <%if(gubun.equals("park_condition")){%>selected<%}%>>������/����������</option>
							<option value='car_gu2' 	<%if(gubun.equals("car_gu2")){%>selected<%}%>>�ڻ�������</option>
						</select>
				        &nbsp;<input type="text" name="gubun_nm" value="<%=gubun_nm%>" class="text" size="15" onKeydown="javascript:EnterDown()">
          			</td>
          			<td class=title width=10%>����</td>
          			<td width=40%>&nbsp;
        				<select name='sort_gubun' style="width: 150px;">
          					<option value='car_kind' 	<%if(sort_gubun.equals("")||sort_gubun.equals("car_kind")){%>selected<%}%>>����</option>		  		  
							<option value='fuel_kd' 	<%if(sort_gubun.equals("fuel_kd")){%>selected<%}%>>����</option>
							<option value='colo' 		<%if(sort_gubun.equals("colo")){%>selected<%}%>>����</option>		  
							<option value='init_reg_dt'   <%if(sort_gubun.equals("init_reg_dt")){%>selected<%}%>>���ʵ����</option>		  
							<option value='today_dist2'   <%if(sort_gubun.equals("today_dist2")){%>selected<%}%>>����Ÿ�</option>
							<option value='fee_amt' 	<%if(sort_gubun.equals("fee_amt")){%>selected<%}%>>���뿩��</option>
							<option value='car_no' 	<%if(sort_gubun.equals("car_no")){%>selected<%}%>>������ȣ</option>
							<option value='car_nm' 	<%if(sort_gubun.equals("car_nm")){%>selected<%}%>>����</option>		  
							<option value='dpm' 		<%if(sort_gubun.equals("dpm")){%>selected<%}%>>��ⷮ</option>
							<option value='situation'     <%if(sort_gubun.equals("situation")){%>selected<%}%>>��������</option>
							<option value='secondhand_dt' <%if(sort_gubun.equals("secondhand_dt")){%>selected<%}%>>�縮�������</option>
						</select>
						&nbsp;&nbsp;<a href="javascript:ybSearch()" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='�˻�'><img src=../images/center/button_search.gif border=0 align=absmiddle></a>
          			</td>
				</tr>
   			</table>			
	  	</td>
	</tr>
  	<tr align="right">
    	<td>
    		<%if(auth_rw.equals("6")){%>		
				<a href="javascript:cancelSecondhand();" title='�縮�����'><img src=../images/center/button_sl_cancel.gif border=0 align=absmiddle></a>&nbsp;
			<%}%>
    	</td>
  	</tr>
</table>

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>