<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String g_fm	 	= request.getParameter("g_fm")==null?"":request.getParameter("g_fm");
	String dt		= request.getParameter("dt")==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String sort 	= request.getParameter("sort")==null?gubun2:request.getParameter("sort");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchRentCond()
{
	var theForm = document.form1;
	theForm.target = "c_foot";
	theForm.submit();
}
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchRentCond();
}
function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}

	//���÷��� Ÿ��
	function cng_input(){
		var fm = document.RentCondSearchForm;
		if(fm.gubun3.options[fm.gubun3.selectedIndex].value != ''){
			td_user.style.display 	= '';
		}else{
			td_user.style.display 	= 'none';
		}
	}
function go_list()
{
	var theForm = document.form1;
	theForm.action = "rent_email_frame.jsp";
	theForm.target = "d_content";
	theForm.submit();
}		
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>

<form action="./rent_email_l_sc.jsp" name="form1" method="POST" target="c_foot">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ������Ȳ > <span class=style5>����� �̸��ϵ����Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr> 
        <td> 
            <table width="100%" border=0 cellspacing=1>
                <tr>
                    <td width="200">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
                      ���� 
                      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                      ��� 
                      <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                      ���� &nbsp;&nbsp;&nbsp;</td>
                    <td colspan="3"><img src=../images/center/arrow_ddj.gif align=absmiddle>&nbsp;&nbsp;
                      &nbsp;<select name="gubun2">
                        <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>���ʿ�����</option>
                        <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>���������</option>
                      </select> <select name='gubun3'>
                        <option value="">������</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(gubun3.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                        </select> &nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_g.gif align=absmiddle>
                      &nbsp;<select name="gubun4">
                        <option value="">��ü</option>
                        <option value="�����̿���" <%if(gubun4.equals("�����̿���"))%>selected<%%>>�����̿���</option>
                        <option value="����������" <%if(gubun4.equals("����������"))%>selected<%%>>����������</option>
                        <option value="ȸ�������" <%if(gubun4.equals("ȸ�������"))%>selected<%%>>ȸ�������</option>
                        <option value="���������" <%if(gubun4.equals("���������"))%>selected<%%>>���������</option>
                        <option value="�������" <%if(gubun4.equals("�������"))%>selected<%%>>�������</option>
                      </select></td>
                    <td><img src=../images/center/arrow_reg_gb.gif align=absmiddle>
                      &nbsp;<select name="gubun5">
                        <option value="">��ü</option>
                        <option value="1" <%if(gubun5.equals("1"))%>selected<%%>>���</option>
                        <option value="2" <%if(gubun5.equals("2"))%>selected<%%>>�̵��</option>
                        <option value="3" <%if(gubun5.equals("3"))%>selected<%%>>���Űź�</option>
                      </select>&nbsp;<a href="javascript:SearchRentCond()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
                    <td>
                      <!--����:
                      <select name="sort" onChange='javascript:SearchRentCond()'>
                        <option value="1" <%if(sort.equals("1"))%>selected<%%>>�����</option>
                        <option value="2" <%if(sort.equals("2"))%>selected<%%>>�뿩������</option>
                        <option value="3" <%if(sort.equals("3"))%>selected<%%>>��ȣ</option>
                        <option value="4" <%if(sort.equals("4"))%>selected<%%>>���ʿ�����</option>
                        <option value="5" <%if(sort.equals("5"))%>selected<%%>>��������</option>
                        <option value="6" <%if(sort.equals("6"))%>selected<%%>>�������</option>
                      </select>-->
                    </td> 
                    <td align="right"><a href="javascript:go_list();"><img src=../images/center/button_list.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>