<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"0":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");

	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 3; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
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

		fm.action = 'asset_s5_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function ChangeDT(arg)
	{
		var theForm = document.form1;
		if(arg=="st_dt")
		{
		theForm.st_dt.value = ChangeDate(theForm.st_dt.value);
		}else if(arg=="end_dt"){
		theForm.end_dt.value = ChangeDate(theForm.end_dt.value);
		}
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
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > �ڻ���� > <span class=style5>
						�ڻ�Ű���Ȳ</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>    
    <tr>
        <td  >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_jh.gif" align=absmiddle>&nbsp; 
     		 <input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>
		���� 
		<input type="radio" name="chk1" value="2" <%if(chk1.equals("2")){%> checked <%}%>>
		��� 
		<input type="radio" name="chk1" value="3" <%if(chk1.equals("3")){%> checked <%}%>>
		�Ⱓ &nbsp;
		<input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text" onBlur="javascript:ChangeDT('st_dt')">
		&nbsp;~&nbsp;
		<input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text" onBlur="javascript:ChangeDT('end_dt')" > 
		&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>  
    
    </tr>
      
    <tr> 
        <td>
            <table width="100%" cellspacing=0 border="0" cellpadding="0">
                <tr>
                  <td width=15%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_yod.gif" >&nbsp;
                      <select name="s_kd" >
                        <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>��ü&nbsp;&nbsp;&nbsp;</option>
                        <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>����&nbsp;&nbsp;&nbsp;</option>
                        <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>��Ʈ&nbsp;&nbsp;&nbsp;</option>
                        <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>��Ʈ-LPG</option>
                        <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>��Ʈ-��LPG</option>
                      </select>
              	  </td>              	  
              	  <td width=20%><img src="/acar/images/center/arrow_gmj.gif" align=absmiddle>&nbsp; 
                      <select name="s_au" >
                        <option value=""  <%if(s_au.equals("")){%> selected <%}%>>��ü&nbsp;&nbsp;&nbsp;</option>
                        <option value="000502" <%if(s_au.equals("000502")){%> selected <%}%>>��ȭ-����۷κ�&nbsp;</option>
                        <option value="013011" <%if(s_au.equals("013011")){%> selected <%}%>>�д�-����۷κ�&nbsp;</option>   
                        <option value="061796" <%if(s_au.equals("061796")){%> selected <%}%>>���-����۷κ�&nbsp;</option>                      
				      <option value="020385" <%if(s_au.equals("020385")){%> selected <%}%>>�������̼�ī�ֽ�ȸ��&nbsp;&nbsp;</option>
				      <option value="022846" <%if(s_au.equals("022846")){%> selected <%}%>>�Ե���Ż&nbsp;&nbsp;</option>		      
				      <option value="048691" <%if(s_au.equals("048691")){%> selected <%}%>>����ġ�����̿���-��������&nbsp;&nbsp;</option>
				        <option value="004242" <%if(s_au.equals("004242")){%> selected <%}%>>�����ڵ�����žؿ������ϻ�</option>		    
				        <option value="003226" <%if(s_au.equals("003226")){%> selected <%}%>>(��)�������&nbsp;&nbsp;&nbsp;</option>
				      <option value="011723" <%if(s_au.equals("011723")){%> selected <%}%>>(��)�����ڵ������&nbsp;&nbsp;</option>
				      <option value="013222" <%if(s_au.equals("013222")){%> selected <%}%>>��ȭ����ũ&nbsp;&nbsp;</option>
		       			 <option value="A" <%if(s_au.equals("A")){%> selected <%}%>>���������&nbsp;&nbsp;&nbsp;</option>
                        <option value="M" <%if(s_au.equals("M")){%> selected <%}%>>���Կɼ�&nbsp;&nbsp;&nbsp;</option>
                        <option value="S" <%if(s_au.equals("S")){%> selected <%}%>>���ǸŰ�&nbsp;&nbsp;&nbsp;</option>
                        <option value="P" <%if(s_au.equals("P")){%> selected <%}%>>����&nbsp;&nbsp;&nbsp;</option>
                      </select>
                     </td>                                                                             
                   <td width=*><img src="/acar/images/center/arrow_ssjh.gif" align=absmiddle>&nbsp;
		&nbsp;<select name="gubun">
			<option value="car_no" 		<%if(gubun.equals("car_no"))%> 		selected<%%>>������ȣ</option>		
		</select>&nbsp;<input type="text" name="gubun_nm" size="12" value="<%=gubun_nm%>" class="text">
		&nbsp;&nbsp;&nbsp;		  		  		 
    	       <img src="/acar/images/center/arrow_ssjh.gif" align=absmiddle>&nbsp;
                      <select name='sort' onChange='javascript:Search()'>
                        <option value='0' <%if(sort.equals("0")){%> selected <%}%>>�Ű���</option>
                        <option value='1' <%if(sort.equals("1")){%> selected <%}%>>�����</option>
                      </select>
                </td>
                           
             </tr>
            </table>
        </td>   
    </tr>
</table>
</form>
</body>
</html>
