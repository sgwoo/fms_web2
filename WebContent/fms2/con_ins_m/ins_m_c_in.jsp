<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.con_ins_m.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	Vector ins_m_scd = ae_db.getInsurMScd(m_id, l_cd, c_id, accid_id, serv_id);
	int ins_scd_size = ins_m_scd.size();
%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='tot_tm' value='<%=ins_scd_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <%	if(ins_scd_size>0){
		for(int i = 0 ; i < ins_scd_size ; i++){
			InsMScdBean ins_ms = (InsMScdBean)ins_m_scd.elementAt(i);
	   		if(ins_ms.getGubun().equals("미수금")){ //미입금%>
                <tr> 
                    <td align='center' width=4%><%=i+1%></td>
                    <td align='center' width=7%><a href="javascript:parent.view_cont('<%=ins_ms.getAccid_id()%>', '<%=ins_ms.getServ_id()%>', '<%=ins_ms.getServ_st()%>')"><%=ins_ms.getServ_st()%></a></td>
                    <td align='left' width=10%>&nbsp;<span title='<%=ins_ms.getOff_nm()%>'><%=Util.subData(String.valueOf(ins_ms.getOff_nm()), 7)%></span></td>
                    <td align='right' width=9%><%=Util.parseDecimal(ins_ms.getTot_amt())%>원&nbsp;</td>
                    <td align='right' width=9%> 
                      <input type='text' name='cust_amt' size='9' value='<%=Util.parseDecimal(ins_ms.getCust_amt())%>' class='num' readonly >
                      원&nbsp;</td>
                    <td align='center' width=9%>
                      <input type='text' name='cust_plan_dt' size='11' value='<%=ins_ms.getCust_plan_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align='center' width=8%'> 
                      <input type='text' name='cust_pay_dt' size='11' value='<%=ins_ms.getCust_pay_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align='right' width=9%><input type='text' name='pay_amt' size='9' class='num' maxlength='10' value='<%=Util.parseDecimal(ins_ms.getPay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>원&nbsp;</td>
                    <td align='center' width=8%> 
                      <%=ins_ms.getExt_dt()%>
                    </td>
                    <td align='right' width=5%><%=ins_ms.getDly_days()%>일&nbsp;</td>
                    <td align='right' width=6%><%=Util.parseDecimal(ins_ms.getDly_amt())%>원&nbsp;</td>
                    <td align='center' width=10%>-</td>
                    <td align='center' width=6%> 
                      <%	if(auth_rw.equals("4") || auth_rw.equals("6")){%>
                      	<a href="javascript:parent.change_scd('u', 'N', '<%=i%>', '<%=ins_ms.getAccid_id()%>', '<%=ins_ms.getServ_id()%>', '<%=ins_ms.getExt_tm()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>                      
                      <%	}else{%>
                      - 
                      <%	}%>
                    </td>
                </tr>
          <%			}else{//입금%>
                <tr> 
                    <td class='is' align='center' width=4%><%=i+1%></td>
                    <td class='is' align='center' width=7%><a href="javascript:parent.view_cont('<%=ins_ms.getAccid_id()%>', '<%=ins_ms.getServ_id()%>', '<%=ins_ms.getServ_st()%>')"><%=ins_ms.getServ_st()%></a></td>
                    <td class='is' align='left' width=10%>&nbsp;<span title='<%=ins_ms.getOff_nm()%>'><%=Util.subData(String.valueOf(ins_ms.getOff_nm()), 7)%></span></td>
                    <td class='is' align='right' width=9%><%=Util.parseDecimal(ins_ms.getRep_amt())%>원&nbsp;</td>
                    <td class='is' align='right' width=9%> 
                      <input type='text' name='cust_amt' size='9' value='<%=Util.parseDecimal(ins_ms.getCust_amt())%>' class='isnum' readonly>
                      원&nbsp;</td>
                    <td class='is' align='center'  width=9%>
                     <input type='text' name='cust_plan_dt' size='11' value='<%=ins_ms.getCust_plan_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class='is' align='center' width=8%> 
                      <input type='text' name='cust_pay_dt' size='11' value='<%=ins_ms.getCust_pay_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class='is' align='right' width=9%><input type='text' name='pay_amt' size='9' class='num' maxlength='10' value='<%=Util.parseDecimal(ins_ms.getPay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>원&nbsp;</td>
                    <td class='is' align='center' width=8%> 
                      <%=ins_ms.getExt_dt()%>
                    </td>
                    <td class='is' align='right' width=5%><%=ins_ms.getDly_days()%>일&nbsp;</td>
                    <td class='is' align='right' width=6%><%=Util.parseDecimal(ins_ms.getDly_amt())%>원&nbsp;</td>
                    <td class='is' align='center' width=10%> 
                      <%	if(auth_rw.equals("4") || auth_rw.equals("6")){%>
					  <%		if(!ins_ms.getCust_pay_dt().equals("") && ins_ms.getExt_v_amt()==0){%>					  
					  <%			if(!ins_ms.getSeqId().equals("")){//트러스빌 입금표 연동%>						  
					  <a href="javascript:parent.viewDepoSlip('<%=ins_ms.getPubCode()%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>&nbsp; 
					  <%			}else{//입금표 발행%>
					  <a href="javascript:parent.reg_payebill('e', 'Y', '<%=i%>', '<%=ins_ms.getAccid_id()%>', '<%=ins_ms.getServ_id()%>', '<%=ins_ms.getExt_tm()%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>&nbsp; 
					  <%			}%>
					  <%		}%>					  
                      <a href="javascript:parent.change_scd('c', 'Y', '<%=i%>', '<%=ins_ms.getAccid_id()%>', '<%=ins_ms.getServ_id()%>', '<%=ins_ms.getExt_tm()%>')"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a> 
                      <%	}else{%>
                      - 
                      <%	}%>
                    </td>
                    <td class='is' align='center' width=6%> 
                      <%	if(auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:parent.change_scd('u', 'Y', '<%=i%>', '<%=ins_ms.getAccid_id()%>', '<%=ins_ms.getServ_id()%>', '<%=ins_ms.getExt_tm()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a> 
                      <%	}else{%>
                      - 
                      <%	}%>
                    </td>
                </tr>
          <%			}
		}
	}else{%>
                <tr> 
                    <td colspan='14' align='center'> 면책금스케줄이 없습니다 </td>
                </tr>
          <%	}%>
            </table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
