<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	st_dt = st_dt.replace("-","");
	end_dt = end_dt.replace("-","");
	
	
	Vector vt = d_db.getClsDocListExcel(s_kd, t_wd, "2",st_dt,end_dt);
	int vt_size = vt.size();

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

<table border="0" cellspacing="0" cellpadding="0" width='800'>
    <tr>
        <td height="40" align="center" style="font-size : 20pt;"><b>��������� ����, ���� ����Ʈ</b></td>
    </tr>
    <tr>
        <td align='right'>�ѰǼ� : <%=vt_size%>��</td>
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
	                             802ȣ (���ǵ���, ����̾ؾ�����)<br><br>
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
        <td class=title> 
     		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    
                    <td width='50' class='title'>����</td>
                    <td width='100' class='title'>������ȣ</td>								
                    <td width='150' class='title'>���ǹ�ȣ</td>
                    <td width='100' class='title'>��ȣ��</td>
                    <td width='60' class='title'>����</td>
                    <td width='100' class='title'>����ڹ�ȣ</td>
                    <td width='100' class='title'>���������</td>
                    <td width='100' class='title'>���踸����</td>
                    <td width='100' class='title'>�輭�׸��</td>
                    <td width='100' class='title'>������</td>
                    <td width='100' class='title'>������</td>	
                </tr>			
           </table>
        </td>
    </tr>
    <%if(vt.size() > 0 ){%>
	            <tr>
                    <td width=530 class='' id='td_con' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                <% for(int i=0; i< vt.size(); i++){
					Hashtable car = (Hashtable)vt.elementAt(i); %>
                            <tr  > 
	                            <td width='50' align='center'><%=i+1%></td>					
	                        	   <td width='100' align='center'><%=car.get("CAR_NO")%></td>
	                            <td width='150' <%if((car.get("INS_STS")+"").equals("1")){%><%}else{%>style="color:red;"<%}%>><%=car.get("INS_CON_NO")%></td>
	                            <td width='100' align='left'>&nbsp;<%=car.get("FIRM_NM")%></td>
	                            <td width='60' align='center'><%=car.get("CAR_NM")%></td>
	                            <td width='100' align='left'>&nbsp;<%if((car.get("CLIENT_ST")+"").equals("1")){%><%=car.get("ENP_NO")%><%}else if((car.get("CLIENT_ST")+"").equals("2")){%><%=AddUtil.subDataCut(car.get("SSN")+"",6)%><%}else{%><%=car.get("ENP_NO")%><%}%></td>
	                    		   <td width='100' align='left'>&nbsp;<%=car.get("INS_START_DT")%></td>
	                            <td width='100' align='left'>&nbsp;<%=car.get("INS_EXP_DT")%></td>
	                            <td width='100'>������</td>                   
	                            <td width='100' align='left'>&nbsp;<%=car.get("BEFORE_EMP_YN")%></td>
	                            <td width='100' align='left'>&nbsp;
	                            	<%if(!(car.get("FIRM_NM2")+"").equals("") && !(car.get("FIRM_NM2")+"").equals(car.get("FIRM_NM")+"") ){%><font color="red">Ȯ���ʿ�</font>
	                            	<%}else{%>�̰���<%}%></td>
                            </tr>
                <%}%>
                            <tr> 
                                <td class='title' colspan='11'>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                  	            </tr>
<%}else{%>
	            <tr>
	                <td width=200 class='line' id='td_con' style='position:relative;'> 
	                    <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td align='center'></td>
                            </tr>
                        </table>
                    </td>
	                <td class='line' width=600> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ش� ������ �����ϴ�.</td>
                            </tr>          
                        </table>
		            </td>
	            </tr>
<%}%>		
            </table>
        </td>
    </tr>
</table>
</body>
</html>
