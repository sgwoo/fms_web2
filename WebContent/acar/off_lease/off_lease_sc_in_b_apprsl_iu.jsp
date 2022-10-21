<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_yb.*"%>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	Offls_ybBean detail = olyD.getYb_detail(car_mng_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();

	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//��ǰ�� ���� ��� �����ϱ� ����
	String apprsl_car_mng_id = olyD.getApprsl_Car_mng_id(car_mng_id);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function ChDate(arg)
{
	var ch_date = replaceString("-","",arg);

	if(ch_date!="")
	{
	if(ch_date.length!=8)
	{
		alert('��¥�� ������ "2002-01-23" �Ǵ� "200020123" �Դϴ�.');
		return "";
	}
	ch_year = parseInt(ch_date.substring(0,4),10);
	ch_month = parseInt(ch_date.substring(4,6),10);
	ch_day = parseInt(ch_date.substring(6,8),10);
	if(isNaN(ch_date))
	{
		alert("���ڿ� '-' ���� �Է°����մϴ�.");
		return "";
	}
	if(!(ch_month>0 && ch_month<13))
	{
		alert("���� 01 - 12 ������ �Է� �����մϴ�.");
		return "";
	}
	ck_day = getDaysInMonth(ch_year,ChangeNum(ch_month))
	if(ck_day<ch_day)
	{
		alert("���� 01 - " + ck_day + " ������ �Է� �����մϴ�.");
		return "";
	}
		
	return ch_year + ""+ChangeNum(ch_month) + ChangeNum(ch_day);
	}else{
	return "";
	}
}
function apprslUpd(ioru)
{
	var fm = document.form1;	
	//var apprsl_dt = ChDate(fm.apprsl_dt.value);
	//if(apprsl_dt != ""){
	//	fm.apprsl_dt_s.value = apprsl_dt;
	//}else{
	//	alert("�����ڸ� �Է��ϼ���!");
	//	return;
	//}
	if(ioru=="i"){
		if(!confirm('�򰡳����� ����Ͻðڽ��ϱ�?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('�򰡳����� �����Ͻðڽ��ϱ�?')){ return; }
	}
	fm.gubun.value = ioru;
	fm.action="./off_lease_apprsl_upd.jsp";
	fm.target = "i_no";
	fm.submit();
}
-->
</script>
</head>
<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǰ��</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
        <%if(apprsl_car_mng_id.equals("")){%>
        <a href='javascript:apprslUpd("i");'><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
        <%}else{%>
        <a href='javascript:apprslUpd("u");'><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
        <%}%>
        <%}%>
        <a href='javascript:history.go(-1);'><img src=../images/center/button_back_p.gif border=0 align=absmiddle></a> 
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td class='title' width=16%> ��ü��</td>
                    <td width=22%>&nbsp; <select name='apprsl_lev'>
                        <option value='0'>����</option>
                        <option value='1' <%if(detail.getLev().equals("1")){%>selected<%}%>>��</option>
                        <option value='2' <%if(detail.getLev().equals("2")){%>selected<%}%>>��</option>
                        <option value='3' <%if(detail.getLev().equals("3")){%>selected<%}%>>��</option>
                      </select> </td>
                    <td class='title' width=14%>������</td>
                    <td align="center" width=18%> <input  class="text" type="text" name="apprsl_dt" size="20" value="<%=AddUtil.ChangeDate2(detail.getApprsl_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                    <td class='title' width=13%>&nbsp;</td>
                    <td width=17%>&nbsp; </td>
                </tr>
                <tr> 
                    <td class='title'>�򰡿���</td>
                    <td colspan="5">&nbsp; <textarea  class="textarea" name="apprsl_reason" cols="142" rows="2"><%=detail.getReason()%></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td colspan="5">&nbsp; <input  class="text" type="text" name="apprsl_car_st" size="70" value="<%=detail.getCar_st()%>"> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�������</td>
                    <td> &nbsp; 
                      <%if(detail.getAccident_yn().equals("1")){%>
                      &nbsp;���� 
                      <%}else{%>
                      &nbsp;���� 
                      <%}%>
                    </td>
                    <td class='title'>�����</td>
                    <td>&nbsp; <select name="damdang_id">
                        <option value='' <%if(detail.getDamdang_id().equals("")){%>selected<%}%>>����</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	
        %>
                        <option value='<%=user.get("USER_ID")%>' <%if(detail.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%
        						}
        					}		%>
                      </select> </td>
                    <td class='title'>����������</td>
                    <td>&nbsp; 
                      <%if(login.getAcarName(detail.getModify_id()).equals("error")){%>
                      &nbsp; 
                      <%}else{%>
                      <%=login.getAcarName(detail.getModify_id())%> 
                      <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <tr> 
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ݳ��� ����������</span></td>
        <td align="right">&nbsp; </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" align='left' class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=16%> ������</td>
                    <td width=84% colspan="5">&nbsp; <select name='driver'>
                        <option value='0'>����</option>
                        <option value='1' <%if(detail.getDriver().equals("1")){%>selected<%}%>>�ӿ�</option>
                        <option value='2' <%if(detail.getDriver().equals("2")){%>selected<%}%>>����</option>
                      </select> </td>
                </tr>
            </table>
        </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
