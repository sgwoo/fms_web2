<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_ins_s2_sc_excel_38.xls");
%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"3":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String mod_st = request.getParameter("mod_st")==null?"":request.getParameter("mod_st");
	
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	
	InsEtcDatabase ie_db = InsEtcDatabase.getInstance();
	
	Vector inss = ie_db.getInsStatList1_excel(br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st, mod_st);
	int ins_size = inss.size();
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width='2680'>
    <tr>
        <td height="40" align="center" style="font-size : 20pt;"><b>�������ս�û��</b></td>
    </tr>
    <tr>
        <td align='right'>�ѰǼ� : <%=ins_size%>��</td>
    </tr>    
    <tr>
	<td height="25" style="font-size : 12pt;">�ͻ�� ü���� ��� �ڵ��� ���� û�༭�� ���ʼ���(���γ���)�� �Ͽ��� �ϳ� �ε����� ������ ���Ͽ� �ϱ�ǿ� ���ؼ��� ��Ȯ�μ��� ��ü�ϰ����մϴ�.</td>
    </tr>    
    <tr> 
      <td height="10" align='center'></td>
    </tr>    
    <tr>
	<td height="25" style="font-size : 12pt;">�ͻ�� ü���� �ڵ��� ���� û�༭ ���� ��� ������ �����ϸ� Ư�� �ϱ� ���ǿ� ���Ͽ� �ٽ��ѹ� Ȯ���ϸ� ��� ���ǵ� �������� ���� ���� Ȯ���մϴ�.</td>
    </tr>    
    <tr>
	<td>&nbsp;</td>
    </tr>           
    <tr>
	<td align='right' height="50" style="font-size : 15pt;">
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
	        <tr>
	            <td width='860' >&nbsp;</td>
	            <td width='100' valign="top" >�ǰ����� : </td>
	            <td width='300' >����� �������� �ǻ���� 8,<br>
	                             802ȣ (���ǵ���, ������� 802ȣ)<br><br>
	                             <span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;��
	            </td>
	            <td width='80' ><img src="/acar/images/stamp.png" width="75" height="75"></td>
	        </tr>
	    </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;</td>
    </tr>                
    <tr> 
        <td > 
     		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr class=title> 
                    
                    <td width='50' class='title'>����</td>				
                    <td width='100' class='title'>�������</td>
                    <td width='100' class='title'>���Ժ����</td>
                    <td width='100' class='title'>������</td>
                    <td width='100' class='title'>������ȣ</td>
                    <td width='150' class='title'>�����ȣ</td>					
                    <td width='150' class='title'>����</td>
                    <td width='100' class='title'>����</td>					
                    <td width='50' class='title'>����<br>����</td>					
                    <td width='100' class='title'>���ʵ����</td>										
                    <td width='50' class='title'>�����</td>
                    <td width='50' class='title'>�ڵ�<br>���ӱ�</td>
                    <td width='50' class='title'>ABS<br>��ġ</td>					
                    <td width='50' class='title'>��<br>�ڽ�</td>			
                    <td width='50' class='title'>����</td>
                    <td width='70' class='title'>�빰</td>						
                    <td width='70' class='title'>�ڱ��ü<br>���</td>						
                    <td width='70' class='title'>�ڱ��ü<br>�λ�</td>						
                    <td width='70' class='title'>����</td>						
                    <td width='70' class='title'>������</td>						
                    <td width='70' class='title'>����</td>	
                    <td width='100' class='title'>�����������ڵ�������</td>											
                    <td width='130' class='title'>���ǹ�ȣ</td>						
                    <td width='150' class='title'>���ŷ�ó</td>
                    <td width='150' class='title'>���������</td>
                    <td width='150' class='title'>����ڹ�ȣ</td>
                    <td width='150' class='title'>�뿩�Ⱓ</td>
                    <td class='title' width='100' >���ڽ�</td>
                    <td class='title' width='80' >����(���ް�)</td>
                    <td class='title' width='100'>�ø����ȣ</td>			
                </tr>			
              <% 		for (int i = 0 ; i < ins_size ; i++){
    									Hashtable ins = (Hashtable)inss.elementAt(i);
    									
    									//���� ����������� �Ƹ���ī�� �Ѵ�.
    									if(!(ins.get("DOC_NO")+"").equals("") && !(ins.get("FIRM_NM")+"").equals("(��)�Ƹ���ī")){
    										ins.put("FIRM_NM", "(��)�Ƹ���ī");
    										ins.put("ENP_NO", "1288147957");
    										ins.put("AGE_SCP", "26���̻�");
    										ins.put("VINS_GCP_KD", "1���");
    										ins.put("VINS_BACDT_KD", "1���");
    										ins.put("COM_EMP_YN", "N");
    									}
    									%>
                <tr> 
                    
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=i+1%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("INS_COM_NM")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'>&nbsp;</td>														
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_NO")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_NUM")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_NM")%> <%=ins.get("CAR_NAME")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_KD")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("TAKING_P")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INIT_REG_DT")))%></td>										
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("AIR")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("AUTO")%></td>										
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("ABS")%></td>															
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'>
                    	<%if(String.valueOf(ins.get("BLACKBOX")).equals("0") && AddUtil.parseInt(String.valueOf(ins.get("B_AMT")))>0){%>
                    	1
                    	<%}else{%>
                    	<%=ins.get("BLACKBOX")%>
                    	<%}%>
                    </td>		
                    													
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("AGE_SCP")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_GCP_KD")%></td>										
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_BACDT_KD")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_BACDT_KC2")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_CACDT2")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_CANOISR2")%><!--N--></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_SPE2")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("COM_EMP_YN")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'>&nbsp;</td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'  <%if((ins.get("FIRM_EMP_NM")+"").equals("")){%>style="color:green;"<%}else if(!(ins.get("FIRM_EMP_NM")+"").equals((ins.get("FIRM_NM")+""))){%>style="color:red;"<%}%>  ><%=ins.get("FIRM_NM")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("USER_NM")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("ENP_NO")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("RENT_START_DT")%>~<%=ins.get("RENT_END_DT")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("B_COM_NM")%>-<%=ins.get("B_MODEL_NM")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='right'>
                    	<%if(String.valueOf(ins.get("B_COM_NM")).equals("�̳��Ƚ�") && (String.valueOf(ins.get("B_MODEL_NM")).equals("LX100") || String.valueOf(ins.get("B_MODEL_NM")).equals("IX200") || String.valueOf(ins.get("B_MODEL_NM")).equals("IX-200")) && AddUtil.parseDecimal(String.valueOf(ins.get("B_AMT"))).equals("0")){%>
                    	92,727
                    	<%}else{%>
                    	<%=AddUtil.parseDecimal(String.valueOf(ins.get("B_AMT")))%>
                    	<%}%>
                    </td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("B_SERIAL_NO")%></td>										
                </tr>
              <%		}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
