<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/agent/cookies.jsp" %>
<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	String gubun = "0";
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String br_id = "";
	String dt = "2";
	
	if(request.getParameter("gubun") != null)	gubun = request.getParameter("gubun");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	if(request.getParameter("br_id") != null)	br_id = request.getParameter("br_id");
	
	String ccst [] = cdb.getClsCondSta2(dt, ref_dt1, ref_dt2, ck_acar_id);
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-170;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function CarRegList(rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value = rent_mng_id;
	theForm.rent_l_cd.value = rent_l_cd;
	theForm.car_mng_id.value = car_mng_id;
	theForm.cmd.value = reg_gubun;
	theForm.rpt_no.value = rpt_no;
	theForm.firm_nm.value = firm_nm;
	theForm.client_nm.value = client_nm;
	theForm.imm_amt.value = imm_amt;
	

	theForm.action = "./register_frame.jsp";
		
	theForm.target = "d_content"
	theForm.submit();
}
//-->
</script>
</head>
<body leftmargin=15 rightmargin=0>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
		<td>
			 <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td colspan=2><iframe src="./cls_cond_sc_in.jsp?gubun=<%=gubun%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&br_id=<%=br_id%>" name="ClsCondList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>
	<tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td width=10% class=title style='height:38'>����</td>
                    <td width=9% class=title>���������<br>(����)</td>
                    <td width=9% class=title>����������<br>(�縮��)</td>
                    <td width=9% class=title>��������</td>
                    <td width=9% class=title>�����Һ���</td>
                    <td width=9% class=title>���°�</td>
                    <td width=9% class=title>�ߵ�����</td>
                    <td width=9% class=title>��ุ��</td>
                    <td width=9% class=title>�Ű�</td>
                    <td width=9% class=title>���Կɼ�</td>
                    <td width=9% class=title>����</td>
                </tr>
                <tr> 
                    <td class=title>�Ǽ�</td>
                    <td align="right"><%=ccst[6]%> �� &nbsp;</td>
                    <td align="right"><%=ccst[9]%> �� &nbsp;</td>
                    <td align="right"><%=ccst[3]%> �� &nbsp;</td>
                    <td align="right"><%=ccst[2]%> �� &nbsp;</td>
                    <td align="right"><%=ccst[4]%> �� &nbsp;</td>
                    <td align="right"><%=ccst[1]%> �� &nbsp;</td>
                    <td align="right"><%=ccst[0]%> ��</td>
                    <td align="right"><%=ccst[5]%> ��</td>
                    <td align="right"><%=ccst[7]%> ��</td>
                    <td align="right"><%=ccst[8]%> ��</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>