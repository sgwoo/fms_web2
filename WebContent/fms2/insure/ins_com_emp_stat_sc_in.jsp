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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
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
	
	Vector vt = ie_db.getInsComempStatList(gubun1, gubun2, "");
	int vt_size = vt.size();
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	
	//세부리스트
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
		    <td colspan="2" rowspan="4" class='title'>구분</td>
		    <td colspan="9" class='title'>법인</td>
		    <td colspan="3" class='title'>개인/개인사업자</td>				
		    <td width='7%' rowspan="4" class='title'>합계</td>				
	        </tr>
		<tr>
		    <td colspan="3" class='title'>특약가입</td>
		    <td colspan="5" class='title'>미가입</td>
		    <td width='7%' rowspan="3" class='title'>미선택</td>
		    <td width='7%' rowspan="3" class='title'>특약가입</td>
		    <td width='7%' rowspan="3" class='title'>미가입</td>
		    <td width='6%' rowspan="3" class='title'>미선택</td>
		</tr>
		<tr>
		    <td width='7%' rowspan="2" class='title'>대수</td>
		    <td colspan="2" class='title'>스캔</td>
		    <td width='7%' rowspan="2" class='title'>대수</td>
		    <td colspan="2" class='title'>스캔</td>
		    <td colspan="2" class='title'>관리자</td>
		</tr>
		<tr>
		    <td width='7%' class='title'>등록</td>
		    <td width='7%' class='title'>미등록</td>
		    <td width='7%' class='title'>등록</td>
		    <td width='7%' class='title'>미등록</td>
		    <td width='7%' class='title'>승인</td>
		    <td width='7%' class='title'>미승인</td>
		</tr> 
		
                <%if(vt_size > 0){%>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
                %>
		<tr>
		    <%if(i==0){%><td align='center' rowspan='<%=vt_size+1%>'>자<br>동<br>차<br>보<br>험<br>보<br>상<br>개<br>시<br>일<br><br>기<br>준</td><%}%>
		    <td align='center'>D<%if(String.valueOf(ht.get("DAYS")).equals("0")){%>-day<%}else{%><%=ht.get("DAYS")%><%}%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_Y_CNT')"><%=ht.get("CLIENT_1_EMP_Y_CNT")%></a></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_Y_SCAN_Y_CNT')"><%=ht.get("CLIENT_1_EMP_Y_SCAN_Y_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_Y_SCAN_N_CNT')"><%=ht.get("CLIENT_1_EMP_Y_SCAN_N_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_N_CNT')"><%=ht.get("CLIENT_1_EMP_N_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_N_SCAN_Y_CNT')"><%=ht.get("CLIENT_1_EMP_N_SCAN_Y_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_N_SCAN_N_CNT')"><%=ht.get("CLIENT_1_EMP_N_SCAN_N_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_N_SAC_Y_CNT')"><%=ht.get("CLIENT_1_EMP_N_SAC_Y_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_N_SAC_N_CNT')"><%=ht.get("CLIENT_1_EMP_N_SAC_N_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_NULL_CNT')"><%=ht.get("CLIENT_1_EMP_NULL_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_2_EMP_Y_CNT')"><%=ht.get("CLIENT_2_EMP_Y_CNT")%></td>
    		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_2_EMP_N_CNT')"><%=ht.get("CLIENT_2_EMP_N_CNT")%></td>
    		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_2_EMP_NULL_CNT')"><%=ht.get("CLIENT_2_EMP_NULL_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CNT')"><%=ht.get("CNT")%></td>
		</tr>
		<%	}%>
                <%}%>    
                
                <%
                	vt = ie_db.getInsComempStatList(gubun1, gubun2, "etc");
			vt_size = vt.size();
                %>
                
                <%if(vt_size > 0){%>
                <%	for(int i = 0 ; i < 1 ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
                %>
		<tr>		   
		    <td align='center'>D+1일 이상 경과</td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_Y_CNT')"><%=ht.get("CLIENT_1_EMP_Y_CNT")%></a></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_Y_SCAN_Y_CNT')"><%=ht.get("CLIENT_1_EMP_Y_SCAN_Y_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_Y_SCAN_N_CNT')"><%=ht.get("CLIENT_1_EMP_Y_SCAN_N_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_N_CNT')"><%=ht.get("CLIENT_1_EMP_N_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_N_SCAN_Y_CNT')"><%=ht.get("CLIENT_1_EMP_N_SCAN_Y_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_N_SCAN_N_CNT')"><%=ht.get("CLIENT_1_EMP_N_SCAN_N_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_N_SAC_Y_CNT')"><%=ht.get("CLIENT_1_EMP_N_SAC_Y_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_N_SAC_N_CNT')"><%=ht.get("CLIENT_1_EMP_N_SAC_N_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_1_EMP_NULL_CNT')"><%=ht.get("CLIENT_1_EMP_NULL_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_2_EMP_Y_CNT')"><%=ht.get("CLIENT_2_EMP_Y_CNT")%></td>
    		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_2_EMP_N_CNT')"><%=ht.get("CLIENT_2_EMP_N_CNT")%></td>
    		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CLIENT_2_EMP_NULL_CNT')"><%=ht.get("CLIENT_2_EMP_NULL_CNT")%></td>
		    <td align='center'><a href="javascript:view_stat('<%=ht.get("INS_EXP_DT")%>','CNT')"><%=ht.get("CNT")%></td>
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
