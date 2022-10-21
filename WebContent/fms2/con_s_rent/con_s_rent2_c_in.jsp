<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	Vector vt = rs_db.getConSRent2SettleScd(l_cd);
	int vt_size = vt.size();
%>

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


<form name='form1' action='' method='post' target=''>
<input type='hidden' name='tot_tm' value='<%=vt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%if(vt_size>0){
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				//연체료 셋팅
				boolean flag = rs_db.calDelay(String.valueOf(ht.get("RENT_S_CD")));

	   			if(String.valueOf(ht.get("PAY_ST")).equals("미수금")){%>
                <tr> 
                    <td align='center' width=3%><%=i+1%></td>
                    <td align='center' width=8%><a href="javascript:parent.view_cont('<%=ht.get("RENT_S_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')"><%=ht.get("CAR_NO")%></a></td>
                    <td align='center' width=10%><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 7)%></span></td>
                    <td align='right' width=7%><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원</td>
                    <td align='right' width=6%><%=Util.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%>원</td>
                    <td align='right' width=9%><%=Util.parseDecimal(String.valueOf(ht.get("RENT_AMT")))%>원</td>
                    <td align='center' width=8%><input type='text' name='est_dt' size='11' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align='center' width=8%'><input type='text' name='pay_dt' size='11' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_DT")))%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align='center' width=9%><input type='text' name='pay_amt' size='9' class='num' maxlength='10' value='<%=Util.parseDecimal(String.valueOf(ht.get("PAY_AMT")))%>' onBlur='javascript:this.value=parseDecimal(this.value)'>원&nbsp;</td>
                    <td align='center' width=8%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>
                    <td align='right' width=6%><%=ht.get("DLY_DAYS")%>일</td>
                    <td align='right' width=6%><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%>원</td>
                    <td align='center' width=6%> 
                      <%if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                        <!--<a href="javascript:parent.change_scd('p', 'N', '<%=i%>', '<%=ht.get("RENT_S_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("RENT_ST")%>', '<%=ht.get("TM")%>')"><img src=/acar/images/center/button_in_ig.gif align=absmiddle border=0></a>--> 
                      <%}else{%>
                      - 
                      <%}%>
                    </td>
                    <td align='center' width=6%> 
                      <%if((auth_rw.equals("4") || auth_rw.equals("6"))){%>
                      	<a href="javascript:parent.change_scd('u', 'N', '<%=i%>', '<%=ht.get("RENT_S_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("RENT_ST")%>', '<%=ht.get("TM")%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>                      	
                      <%}else{%>
                      - 
                      <%}%>                      
                    </td>
                </tr>
                <%		}else{//입금%>
                <tr> 
                    <td class='is' align='center' width=3%><%=i+1%></td>
                    <td class='is' align='center' width=8%><a href="javascript:parent.view_cont('<%=ht.get("RENT_S_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')"><%=ht.get("CAR_NO")%></a></td>
                    <td class='is' align='center' width=10%><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 7)%></span></td>
                    <td class='is' align='right' width=7%><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원</td>
                    <td class='is' align='right' width=6%><%=Util.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%>원</td>
                    <td class='is' align='right' width=9%><%=Util.parseDecimal(String.valueOf(ht.get("RENT_AMT")))%>원</td>
                    <td class='is' align='center' width=8%><input type='text' name='est_dt' size='11' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='is' align='center'  width=8%><input type='text' name='pay_dt' size='11' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_DT")))%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='is' align='center' width=9%><input type='text' name='pay_amt' size='9' class='num' maxlength='10' value='<%=Util.parseDecimal(String.valueOf(ht.get("PAY_AMT")))%>' onBlur='javascript:this.value=parseDecimal(this.value)'>원&nbsp;</td>
                    <td class='is' align='center' width=8%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>
                    <td class='is' align='right' width=6%><%=ht.get("DLY_DAYS")%>일</td>
                    <td class='is' align='right' width=6%><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%>원</td>
                    <td class='is' align='center' width=6%> 
                      <%if((auth_rw.equals("4") || auth_rw.equals("6"))){%>
		      -<!--<a href="javascript:parent.reg_payebill('e', 'Y', '<%=i%>', '<%=ht.get("RENT_S_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("RENT_ST")%>', '<%=ht.get("TM")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>-->
                      <%}else{%>
                      - 
                      <%}%>                      
                    </td>
                    <td class='is' align='center' width=6%> 
                      <%if((auth_rw.equals("4") || auth_rw.equals("6"))){%>
                      <a href="javascript:parent.change_scd('u', 'Y', '<%=i%>', '<%=ht.get("RENT_S_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("RENT_ST")%>', '<%=ht.get("TM")%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a> 
                      <%}else{%>
                      - 
                      <%}%>
                    </td>
                </tr>
                <%		}
			}
		}else{%>
                <tr> 
                    <td colspan='14' align='center'> 스케줄이 없습니다 </td>
                </tr>
                <%}%>
            </table>
	</td>
    </tr>
</table>
</form>
</body>
</html>
