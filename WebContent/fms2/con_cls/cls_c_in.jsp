<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.ext.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//대여료 공급가,부가세 계산 세팅
	function cal_sv_amt(idx)
	{
		var fm = document.form1;
		if(idx == 0 && fm.tot_tm.value == '1'){
			fm.cls_amt.value = parseDecimal(toInt(parseDigit(fm.cls_s_amt.value)) + toInt(parseDigit(fm.cls_v_amt.value)));
		}else{
			fm.cls_amt[idx].value = parseDecimal(toInt(parseDigit(fm.cls_s_amt[idx].value)) + toInt(parseDigit(fm.cls_v_amt[idx].value)));
		}
	}
-->
</script>
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
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	Vector cls_scd = ae_db.getClsScd(m_id, l_cd);
	int cls_scd_size = cls_scd.size();
%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='tot_tm' value='<%=cls_scd_size%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
<%	if(cls_scd_size>0){
		for(int i = 0 ; i < cls_scd_size ; i++){
			ExtScdBean cls = (ExtScdBean)cls_scd.elementAt(i);%>
			    <input type='hidden' name='ht_cls_tm' value='<%=cls.getExt_tm()%>'>		
			    <input type='hidden' name='ht_rent_seq' value='<%=cls.getRent_seq()%>'>				
<%	   		if(cls.getGubun().equals("미수금")){ //미입금%>
                <tr> 
                    <td align='center' width=4%><%=i+1%></td>
                    <td align='center' width=8%><input type='text' name='cls_est_dt' size='11' value='<%=cls.getExt_est_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align='right' width=8%><input type='text' name='cls_s_amt' size='8' value='<%=Util.parseDecimal(cls.getExt_s_amt())%>' class='num' onBlur="javascript:this.value=parseDecimal(this.value);cal_sv_amt('<%=i%>')">&nbsp;</td>
                    <td align='right' width=8%><input type='text' name='cls_v_amt' size='8' value='<%=Util.parseDecimal(cls.getExt_v_amt())%>' class='num' onBlur="javascript:this.value=parseDecimal(this.value);cal_sv_amt('<%=i%>')">&nbsp;</td>
                    <td align='right' width=8%><input type='text' name='cls_amt' size='8' value='<%=Util.parseDecimal(cls.getExt_s_amt()+cls.getExt_v_amt())%>' class='num' readonly>&nbsp;</td>
                    <td align='center' width=8%><input type='text' name='pay_dt' size='11' value='<%=cls.getExt_pay_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align='right' width=8%><input type='text' name='pay_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_pay_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>&nbsp;</td>
                    <td align='right' width=7%><%=cls.getDly_days()%>일&nbsp;</td>
                    <td align='right' width=8%><%=Util.parseDecimal(cls.getDly_amt())%>&nbsp;</td>
                    <td align='center' width=7%>
        			
                      <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                        <%	if( nm_db.getWorkAuthUser("전산팀",user_id) ){  //합산에서 구분정산으로 변경시  스케쥬생성후 금액 확인후 변경  %>    
                      <a href="javascript:parent.change_scd_cls('p', 'N', '<%=i%>', '<%=cls.getExt_tm()%>')"><img src=/acar/images/center/button_in_ig.gif align=absmiddle border=0></a>
                    	<% } %>
                      <%	}else{%>
                      -
                      <%	}%>
                  	  
                    </td>
                    <td align='center' width=5%>
        			 
                      <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%> 
                      <a href="javascript:parent.change_scd_cls('u', 'N', '<%=i%>', '<%=cls.getExt_tm()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
                      <%	}else{%>
                      -
                      <%	}%>   
                    </td>
                    <td align='center' width=5%>
        			  
        			  <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){//수정,삭제%>					
        				<a href="javascript:parent.credit(<%=i%>, <%=cls.getExt_tm()%>, 'scd_ext')"><img src=/acar/images/center/button_in_ds.gif align=absmiddle border=0></a>
        			  <%	}else{%>-<%}%>
                   
                    </td>		
                    <td align='center' width=15%><input type='text' name='ext_dt' size='12' value='<%=cls.getExt_dt()%>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value)'></td>				
                </tr>
<%			}else{//입금%>
                <tr> 
                    <td class='is' align='center' width=4%><%=i+1%></td>
                    <td class='is' align='center' width=8%><input type='text' name='cls_est_dt' size='11' value='<%=cls.getExt_est_dt()%>' class='istext'></td>
                    <td class='is' align='right' width=8%><input type='text' name='cls_s_amt' size='8' value='<%=Util.parseDecimal(cls.getExt_s_amt())%>' class='isnum' >&nbsp;</td>
                    <td class='is' align='right' width=8%><input type='text' name='cls_v_amt' size='8' value='<%=Util.parseDecimal(cls.getExt_v_amt())%>' class='isnum' >&nbsp;</td>			
                    <td class='is' align='right' width=8%><input type='text' name='cls_amt' size='8' value='<%=Util.parseDecimal(cls.getExt_s_amt()+cls.getExt_v_amt())%>' class='isnum' >&nbsp;</td>
                    <td class='is' align='center' width=8%><input type='text' name='pay_dt' size='11' value='<%=cls.getExt_pay_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='is' align='right' width=8%><input type='text' name='pay_amt' size='9' value='<%=Util.parseDecimal(cls.getExt_pay_amt())%>' class='isnum' onBlur='javascript:this.value=parseDecimal(this.value)'>&nbsp;</td>
                    <td class='is' align='right' width=7%><%=cls.getDly_days()%>일&nbsp;</td>
                    <td class='is' align='right' width=8%><%=Util.parseDecimal(cls.getDly_amt())%>&nbsp;</td>
                    <td class='is' align='center' width=7%>
        			
                      <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:parent.change_scd_cls('c', 'Y', '<%=i%>', '<%=cls.getExt_tm()%>')"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a>
                      <%	}else{%>
                      -
                      <%	}%>
        		
                    </td>
                    <td class='is' align='center' width=5%>
        			 
                      <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:parent.change_scd_cls('u', 'Y', '<%=i%>', '<%=cls.getExt_tm()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
                      <%	}else{%>
                      -
                      <%	}%>                    
        			
                    </td>	
                    <td class='is' align='center' width=5%>-</td>				
                    <td class='is' align='center' width=15%><input type='text' name='ext_dt' size='12' value='<%=cls.getExt_dt()%>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value)'></td>			
                </tr>		  
<%			}
		}
	}else{%>
                <tr> 
                    <td colspan='13' align='center'>해지정산금 스케줄이 없습니다 </td>
                </tr>
<%	}%>
            </table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
