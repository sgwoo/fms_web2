<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
String sFileName = "���谡����Ȳ_�űԵ����Ȳ" + ".xls";
sFileName = new String ( sFileName.getBytes("KSC5601"), "8859_1");
String fileName = sFileName;
//���� ���� �ٿ�ε� 
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ";");

%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr"><!--������ export�� �ѱ۱��� ���� ����-->
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	int size1 = 0;
	
	if(!st_dt.equals("")) 	st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt = AddUtil.replace(end_dt, "-", "");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector inss = ai_db.getInsStatList_in1(br_id, brch_id, st_dt, end_dt, gubun1, gubun2);
	int ins_size = inss.size();	
	
	long total_amt = 0;
%>
<!--
<p>* �μ⸦ �ϽǷ��� ���� ��ܸ޴����� ����>������������ ���� -> ���������� �������� ���ο� üũ�ϰ� �μ��Ͻʽÿ�. </p>
<P>�� �ϴ��� ������ ���� �� ��ġ�� ���� �� ������ �� �����ϴ�. (������)</P>
<P>��Ģ1 - �����ȣ�� 8�ڸ����� ����(������ �Ǵ� ����, Ư�����ڴ� - ����)</P>
<P>��Ģ2 - �����׸� ���� �Է� ������ XINSA �λ�޿��ý��ۿ��� ���� ��Ģ���� �Է��ؾ� �մϴ�. (��, �ð������� �Է��ϴ� ���� �ð����� �Է�)</P>
-->
<table border="0" cellspacing="0" cellpadding="0" width=1920 bordercolor="#000000">
    <tr> 
        <td class=> 
            <table border="1" cellspacing="1" cellpadding="0" width='100%' bordercolor="#000000">
                <tr> 
                    <td class='title' width='50'>����</td>
                    <td class='title' width="70">��������</td>
                    <td class='title' width="200">����</td>
                    <td class='title' width="100">����ڹ�ȣ</td>
                    <!--<td class='title' width="180">���Ⱓ</td>-->
                    <td class='title' width="100">������ȣ</td>
                    <td class='title' width="150">�����ȣ</td>
                    <td class='title' width="100">�����ڵ�</td>
                    <td class='title' width="150">����</td>
                    <td class='title' width="80">���ʵ����</td>
                    <td class='title' width="70">��ϻ���</td>
                    <td class='title' width="70">���豸��</td>
                    <td class='title' width="100">����ȸ��</td>
                    <td class='title' width="100">���ǹ�ȣ</td>
                    <td class='title' width="180">����Ⱓ</td>
                    <td class='title' width="100">�����</td>
                    <td class='title' width="200">���ڽ�</td>
                    <td class='title' width="100">�ø����ȣ</td>
                    <td class='title' width="100">���ڽ��ݾ�</td>
                </tr>
              <%if(ins_size > 0){%>
              <%	for (int i = 0 ; i < ins_size ; i++){
    								Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ins.get("CAR_ST")%></td>
                    <td align="center"><%=ins.get("FIRM_NM")%></td>
                    <td align="center"><%=ins.get("ENP_NO")%></td>
                    <!--<td align="center"><%=ins.get("RENT_START_DT")%>~<%=ins.get("RENT_END_DT")%></td>-->
                    <td align="center"><%=ins.get("CAR_NO")%></td>
                    <td align="center"><%=ins.get("CAR_NUM")%></td>
                    <td align="center"><%=ins.get("JG_CODE")%></td>
                    <td align="center"><span title='<%=ins.get("CAR_NM")%> <%=ins.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 9)%></span></td>
                    <td align="center"><%=ins.get("INIT_REG_DT")%></td>
                    <td align="center"><%=ins.get("REG_CAU")%></td>
                    <td align="center"><%=ins.get("INS_KD")%></td>
                    <td align="center"><%=ins.get("INS_COM_NM")%></td>
                    <td align="center"><%=ins.get("INS_CON_NO")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
                    <td align=right><%=Util.parseDecimal(String.valueOf(ins.get("INS_AMT")))%></td>
                    <td align=center><%=ins.get("B_COM_NM")%>-<%=ins.get("B_MODEL_NM")%></td>
                    <td align=center><%=ins.get("B_SERIAL_NO")%></td>
                    <td align=right>
                    	<%if(!String.valueOf(ins.get("B_MODEL_NM")).equals("") && AddUtil.parseDecimal(String.valueOf(ins.get("B_AMT"))).equals("0")){%>
                      92,727
                      <%}else{%>
                      <%=AddUtil.parseDecimal(String.valueOf(ins.get("B_AMT")))%>
                      <%}%>
                    </td>
                </tr>
              <%		total_amt = total_amt + Long.parseLong(String.valueOf(ins.get("INS_AMT")));
    			  		}%>
                <tr> 
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>��</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                </tr>
              <%}else{%>
                <tr align="center"> 
                    <td colspan="17">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
