<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_ins_cls_mng_ins_s_excel.xls");
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
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
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
	
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector inss = ai_db.getInsClsMngList2(br_id, gubun0, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
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

<table border="0" cellspacing="0" cellpadding="0" width='800'>
    <tr>
        <td height="40" align="center" style="font-size : 20pt;"><b>���� ��û��</b></td>
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
        <td class=line> 
     		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    
                    <td width='100' class='title'>������ȣ</td>				
                    <td width='120' class='title'>���ǹ�ȣ</td>
                    <td width='120' class='title'>����</td>
                    <td width='100' class='title'>���������߻�����</td>			
                    <td width='100' class='title'>�뵵���泻��</td>			
                    <td width='100' class='title'>�뵵�������</td>			
                    <td width='100' class='title'>û��/�°�����</td>		
                    <td width='100' class='title'>ȯ�ޱ�</td>				
                </tr>			
           </table>
        </td>
    </tr>
    <%if(ins_size > 0 ){%>
	            <tr>
                    <td width=420 class='line' id='td_con' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                <% for(int i=0; i< ins_size; i++){
					Hashtable ins = (Hashtable)inss.elementAt(i); %>
                            <tr> 								
                        		<td width='100' align='center'><%=ins.get("CAR_NO")%></td>
                            <td width='120' align='center'><%=ins.get("INS_CON_NO")%></td>
                            <td width='120' align='center'><%=ins.get("CAR_NM")%></td>
                            <td width='100' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("MIGR_DT")))%></td>	
                            <td width='100' align="center">����</td>	
                            <td width='100' align="center"><%=ins.get("CAU")%></td>	
                            <td width='100' align="center"></td>	
                            <td width='100' align="center"></td>	
                            </tr>
                <%}%>
                            <tr> 
                                <td class='title' colspan='8'>&nbsp;</td>
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
	                <td class='line' width=420> 
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
