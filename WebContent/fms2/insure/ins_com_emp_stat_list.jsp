<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	String ins_exp_dt= request.getParameter("ins_exp_dt")==null?"":request.getParameter("ins_exp_dt");
	String s_stat 	= request.getParameter("s_stat")==null?"":request.getParameter("s_stat");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt1 =0;
	int cnt2 =0;
	int cnt3 =0;
	int cnt4 =0;
	int cnt5 =0;
	int cnt6 =0;
	int cnt7 =0;
	int cnt8 =0;
	int cnt9 =0;
	
	
	
	InsEtcDatabase ie_db = InsEtcDatabase.getInstance();
	
	Vector vt = ie_db.getInsComempStatSubList(gubun1, gubun2, ins_exp_dt, s_stat);
	int vt_size = vt.size();
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	
	//���θ���Ʈ
	function view_stat(ins_exp_dt, s_stat){
		window.open('ins_com_emp_stat_list.jsp?gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&ins_exp_dt='+ins_exp_dt+'&s_stat='+s_stat, "STAT_LIST", "left=0, top=0, width=1050, height=700, scrollbars=yes, status=yes, resize");
	}	
		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line' width='100%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='5%' class='title'>����</td>
		    <td width='10%' class='title'>���踸����</td>
		    <td width='10%' class='title'>����ȣ</td>		    
		    <td width='17%' class='title'>����</td>
		    <td width='10%' class='title'>������ȣ</td>
		    <td width='17%' class='title'>����</td>
		    <td width='5%' class='title'>Ư��<br>����</td>
		    <td width='5%' class='title'>��ĵ<br>���</td>
		    <td width='9%' class='title'>������<br>������</td>
		    <td width='6%' class='title'>����<br>������</td>
		    <td width='6%' class='title'>����<br>�����</td>
		</tr> 
		
                <%if(vt_size > 0){%>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
                %>
		<tr>		    
		    <td align='center'><%=i+1%></td>
		    <td align='center'><%=ht.get("INS_EXP_DT")%></td>
		    <td align='center'><%=ht.get("RENT_L_CD")%></td>
		    <td align='center'><%=ht.get("FIRM_NM")%></td>
		    <td align='center'><%=ht.get("CAR_NO")%></td>
		    <td align='center'><%=ht.get("CAR_NM")%></td>
		    <td align='center'><%=ht.get("COM_EMP_YN")%></td>
		    <td align='center'><%=ht.get("SCAN_CNT")%></td>
		    <td align='center'><%=ht.get("COM_EMP_SAC_DT")%></td>
		    <td align='center'><%=ht.get("BUS_NM")%></td>
    		    <td align='center'><%=ht.get("BUS_NM2")%></td>		    
		</tr>
		<%	}%>
                <%}%>                   
            </table>
        </td>
    </tr>            
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
