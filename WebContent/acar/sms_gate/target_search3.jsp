<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.car_office.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("auth_rw")==null?"S1":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");	

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector branches = c_db.getBranchList(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();
	
	//�õ�
	Vector sidoList = c_db.getZip_sido();
	int sido_size = sidoList.size();

	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="javascript">
<!--

//�ʱ�ȭ
function init(){
	opener.smsList.location.href = "./sms_list2.jsp";
	location.href = "./target_search3.jsp";
}

//�˻���� �θ������쿡�� �����ֱ� 
function SearchCarOffP3(){
	fm = document.form1;
	opener.smsList.smsList_t.location.href = "./sms_list2_t.jsp";	
	fm.target = "smsList_in";
	fm.action = "./sms_list_in2.jsp";
	fm.submit();
}
//�ߺ��� ��ȸ
function check_double(){
	window.open("about:blank", "check_double", "left=30, top=110, width=750, height=550, scrollbars=yes, status=yes");	
	fm = document.form1;
	fm.target = "check_double";
	fm.action = "./sms_list_double.jsp";
	fm.submit();
}
//��ȣ����üũ
function check_num(){
	window.open("about:blank", "check_num", "left=30, top=110, width=750, height=550, scrollbars=yes, status=yes");	
	fm = document.form1;
	fm.target = "check_num";
	fm.action = "./sms_list_check_num.jsp";
	fm.submit();

}

-->
</script>

</head>

<body>
<form name="form1" method="post">
<table width="320" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>SMS > <span class=style5>�߼۸�ܰ˻�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><div align="right"><a href="javascript:init()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_init.gif"  border="0" align="absbottom"></a> 
        <a href="javascript:this.close();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_close.gif" border="0" align="absbottom"></a></div></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="320" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="80" class="title">�߼۴��</td>
                    <td width="237">&nbsp;�������</td>
                </tr>
                <tr> 
                    <td class="title">�߼۹��</td>
                    <td>&nbsp;<% if(gubun2.equals("1")) out.print("����"); else out.print("����"); %></td>
                </tr>
                <tr> 
                    <td colspan="2" align=center><font color="#666666">���ش��׸��� ������ �ֽñ� �ٶ��ϴ�.</font></td>
                </tr>
                <tr> 
                    <td class="title">����</td>
                    <td>&nbsp;
                    <select name='br_id' >
                      <option value=''>��ü</option>
                      <%if(brch_size > 0){
        				for (int i = 0 ; i < brch_size ; i++){
        					Hashtable branch = (Hashtable)branches.elementAt(i);%>
                      <option value='<%= branch.get("BR_ID") %>' <% if(branch.get("BR_ID").equals(br_id)) out.print("selected"); %> ><%= branch.get("BR_NM")%> 
                      </option>
                      <%	}
        			} %>
                    </select></td>
                </tr>
                <tr> 
                    <td class="title">�μ�</td>
                    <td>&nbsp;
                    <select name='dept_id' >
                      <option value=''>��ü</option>
                      <option value='0001' >������</option>
                      <option value='0002' >��������</option>
                      <option value='0003' >�ѹ���</option>
					  <option value='0005' >IT��</option>
                      <option value='0004' >�� ��</option>
                      <option value='0007' >�λ�����</option>
                      <option value='0008' >��������</option>
                       <option value='0009' >��������</option>
                       <option value='0010' >��������</option>
                       <option value='0011' >�뱸����</option>
                       <option value='0012' >��õ����</option>
                       <option value='0013' >��������</option>
                       <option value='1000' >������Ʈ</option>
                      <option value='8888' >�ܺξ�ü</option>
                      <option value='9999'>�����</option>
                    </select></td>
                </tr>
                <tr> 
                    <td class="title">����</td>
                    <td>&nbsp;
                    <input type="text" name="user_nm" size="20" class="text" style="IME-MODE:active;"></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><div align="center"><a href="javascript:SearchCarOffP3()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_search.gif" border="0" align="absbottom"></a></div></td>
    </tr>
</table>
</form>
</body>
</html>
