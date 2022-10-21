<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title ���� */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String prv_mon_yn = request.getParameter("prv_mon_yn")==null?"":request.getParameter("prv_mon_yn");//����������Ⱓ���Կ���
	String cls_dt = request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	int tae_sum = 0;
	
	//��ü�� ����
	boolean flag = af_db.calDelay(m_id, l_cd);
	
	//�Ǻ� �뿩�� ������ ����Ʈ
	Vector fee_scd = af_db.getFeeScdPrint(l_cd, "desc");
	int fee_scd_size = fee_scd.size();
%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='tot_tm' value='<%=fee_scd_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='60%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='6%' class='title' style='height:36'>ȸ��</td>
                    <td width='10%' class='title'>����</td>
                    <td width='13%' class='title'>�Աݿ�����</td>
                    <td width='15%' class='title'>���ް�</td>
                    <td width='13%' class='title'>�ΰ���</td>
                    <td width='15%' class='title'>���뿩��</td>
                    <td width='13%' class='title'>�Ա�����</td>
                    <td width='15%' class='title'>���Աݾ�</td>
                </tr>
	        </table>
	    </td>
	    <td class='line' width='40%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='14%' class='title' style='height:36'>��ü<br>�ϼ�</td>
                    <td width='18%' class='title'>��ü��</td>
                    <td width='12%' class='title'>�Ա�<br>���</td>
                    <td width='22%' class='title'>����<br>����</td>
                    <td width='12%' class='title'>���</td>			
                    <td width='22%' class='title'>���ݰ�꼭<br>��������</td>			
                </tr>
            </table>
	    </td>
    </tr>
<%	if(fee_scd_size>0){%>  
    <tr>
	    <td class='line' width='60%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>	  
<%		for(int i = 0 ; i < fee_scd_size ; i++){
			FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
			if(a_fee.getTm_st2().equals("2") && !prv_mon_yn.equals("1")){
				tae_sum+=1;
			}
			if(a_fee.getRent_l_cd().equals("S104HB4L00012")) tae_sum = 1; //�ѱ����� ���°�� ���Ͽ�(2004-04-22)%>		
				<input type='hidden' name='h_pag_cng_dt' value='<%=a_fee.getPay_cng_dt()%>'>
				<input type='hidden' name='h_pag_cng_cau' value='<%=a_fee.getPay_cng_cau()%>'>
				<input type='hidden' name='ht_tm_st1' value='<%=a_fee.getTm_st1()%>'>
				<input type='hidden' name='ht_fee_tm' value='<%=a_fee.getFee_tm()%>'>
				<input type='hidden' name='ht_rc_yn' value='<%=a_fee.getRc_yn()%>'>								
				<tr>
				<%if(a_fee.getRc_yn().equals("0")){ //���Ա�%>
					<td align='center' width='6%'  ><%if(a_fee.getTm_st2().equals("2")){%><font color=red>b</font><%}%><%if(a_fee.getTm_st1().equals("0") && !a_fee.getTm_st2().equals("2")){%><%=Integer.parseInt(a_fee.getFee_tm())-tae_sum%><%}else{%><%=a_fee.getFee_tm()%><%}%></td>
					<td align='center' width='10%'><input type='text' name='t_tm_st1' size='5' class='whitetext' value='<%if(a_fee.getTm_st1().equals("0")){%>�뿩��<%}else{%>�ܾ�<%}%>' readonly></td>
					<td align='center' width='13%'><input type='text' name='t_fee_est_dt' size='9' class='whitetext' value='<%=a_fee.getFee_est_dt()%>' readonly></td>
					<td align='right'  width='15%'><input type='text' name='t_fee_s_amt' size='8' class='whitenum' value='<%=Util.parseDecimal(a_fee.getFee_s_amt())%>' readonly>��&nbsp;</td>
					<td align='right'  width='13%'><input type='text' name='t_fee_v_amt' size='6' class='whitenum' value='<%=Util.parseDecimal(a_fee.getFee_v_amt())%>' readonly>��&nbsp;</td>
					<td align='right'  width='15%'><input type='text' name='t_fee_amt' size='8' value='<%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>' maxlength='10' onBlur='javascript:parent.cal_sv_amt(<%=i%>)' class='whitenum' readonly>��&nbsp;</td>
					<td align='center' width='13%'>
					<%if(a_fee.getBill_yn().equals("Y")){%>
					<input type='text' name='t_rc_dt' value='' size='9' class='whitenum' readonly>
					<%}else{%>
					<%=cls_dt%>
					<%}%>							
					</td>
					<td align='center' width='15%'>
					<%if(a_fee.getBill_yn().equals("Y")){%>
					<input type='text' name='t_rc_amt' value='' size='8' class='whitenum' readonly>
					<%}else{%>
					��������
					<%}%>								
					</td>
				<%}else{//�ԱݵȰ�%>
					<td class='is' align='center'  ><%if(a_fee.getTm_st2().equals("2")){%><font color=red>b</font><%}%><%if(a_fee.getTm_st1().equals("0") && !a_fee.getTm_st2().equals("2")){%><%=Integer.parseInt(a_fee.getFee_tm())-tae_sum%><%}else{%><%=a_fee.getFee_tm()%><%}%></td>
					<td class='is' align='center'><input type='text' name='t_tm_st1' size='5' class='istext' value='<%if(a_fee.getTm_st1().equals("0")){%>�뿩��<%}else{%>�ܾ�<%}%>' readonly></td>
					<td class='is' align='center'><input type='text' name='t_fee_est_dt' size='9' class='istext' value='<%=a_fee.getFee_est_dt()%>' readonly></td>
					<td class='is' align='right'><input type='text' name='t_fee_s_amt' size='8' class='isnum' value='<%=Util.parseDecimal(a_fee.getFee_s_amt())%>' readonly>��&nbsp;</td>
					<td class='is' align='right'><input type='text' name='t_fee_v_amt' size='6' class='isnum' value='<%=Util.parseDecimal(a_fee.getFee_v_amt())%>' readonly>��&nbsp;</td>
					<td class='is' align='right'><input type='text' name='t_fee_amt' size='8' value='<%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>' class='isnum' readonly>��&nbsp;</td>
					<td class='is' align='center'><input type='text' name='t_rc_dt' value='<%=a_fee.getRc_dt()%>' size='9' maxlength='10' class='istext' readonly></td>
					<td class='is' align='right'><input type='text' name='t_rc_amt' value='<%=Util.parseDecimal(a_fee.getRc_amt())%>' size='8' class='isnum' readonly>��&nbsp;</td>
				<%}%>
				</tr>
<%		}%>				
	        </table>
	    </td>
	    <td class='line' width='40%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for(int i = 0 ; i < fee_scd_size ; i++){
			FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);%>
                <tr>
				<%if(a_fee.getRc_yn().equals("0")){ //���Ա�%>
					<td align='right' width='14%'  ><%=a_fee.getDly_days()%>��&nbsp;</td>
					<td align='right' width='18%'><%=Util.parseDecimal(a_fee.getDly_fee())%>��&nbsp;</td>
					<td align='center' width='12%'>
					<%if(a_fee.getBill_yn().equals("Y")){%>
					<%//	if(br_id.equals("S1") || br_id.equals(brch_id)){%>
					<%		if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){//�Ա�%>										
						<a href="javascript:parent.pay_fee(<%=i%>, <%=a_fee.getRent_st()%>)"><img src=/acar/images/center/button_in_ig.gif align=absmiddle border=0></a>					
					<%		}else{%>-<%}%>
					<%//	}%>
					<%}%>					
					</td>
					<td width='22%' align="center">
					<%if(a_fee.getBill_yn().equals("Y")){%>
					<%//	if(br_id.equals("S1") || br_id.equals(brch_id)){%>					
					<%		if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){//����,����%>					
						<a href="javascript:parent.change_scd(<%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a> 
						<%		if(!a_fee.getTm_st2().equals("0") && (auth_rw.equals("5") || auth_rw.equals("6"))){//����%>
						<%		}%>
					<%		}else{%>-<%}%>
					<%//	}%>
					<%}%>					
					</td>				
					<td align='center' width='12%'>
					<%if(a_fee.getBill_yn().equals("Y")){%>
					<%//	if(br_id.equals("S1") || br_id.equals(brch_id)){%>
					<%		if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){//����,����%>					
						<a href="javascript:parent.credit(<%=i%>, <%=a_fee.getRent_st()%>, 'scd_fee')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_ds.gif align=absmiddle border=0></a>
					<%		}else{%>-<%}%>	
					<%//	}%>
					<%}%>
					</td>
					<td align='center' width='22%'><input type='text' name='t_fee_ext_dt' size='12' class='whitetext' value='<%=AddUtil.ChangeDate2(a_fee.getExt_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value);'></td>											
				<%}else{//�ԱݵȰ�%>
					<td class='is' align='right' width='14%' ><%=a_fee.getDly_days()%>��&nbsp;</td>
					<td class='is' align='right' width='18%'><%=Util.parseDecimal(a_fee.getDly_fee())%>��&nbsp;</td>					
		            <td class='is' align='center' width='12%'> 
					  <%if(a_fee.getBill_yn().equals("Y")){%>
					  <%//	if(br_id.equals("S1") || br_id.equals(brch_id)){%>
        		      <%		if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){//�Ա����%>
		              <a href="javascript:parent.cancel_rc(<%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"> 
        		      <%			if((!a_fee.getRc_yn().equals("0"))&&(a_fee.getIslast().equals("Y"))){%>
		              <img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0> 
        		      <%			}%>
		              </a> 
		              <%		}else{%>
		              <%			if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){//�Ա�%>
		              - 
        		      <%			}else{%>
		              - 
        		      <%			}%>
	              	  <%		}%>
	              	  <%//	}%>					  
					  <%}%>
 		            </td>
					<td class='is' align='center' width='22%'>
					  <%if(a_fee.getBill_yn().equals("Y")){%>
					  <%//	if(br_id.equals("S1") || br_id.equals(brch_id)){%>
					  <%		if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){//����,����%>										
					  <a href="javascript:parent.change_scd(<%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a> 
					  <%			if(!a_fee.getTm_st2().equals("0") && (auth_rw.equals("5") || auth_rw.equals("6"))){%>
					  &nbsp;<a href="javascript:parent.ext_scd('DROP', <%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a> 
					  <%			}%>
					  <%		}else{%>-<%}%>
					  <%//	}%>
					  <%}%>
					</td>			
					<td class='is' align='center' width='12%'>-</td>							
					<td class='is' align='center' width='22%'><input type='text' name='t_fee_ext_dt' size='11' class='whitetext' value='<%=AddUtil.ChangeDate2(a_fee.getExt_dt())%>' readonly></td>
				<%}%>
				</tr>				
<%		}//for end%>
            </table>
	    </td>
    </tr>
<%	}else{%>        
    <tr>
	    <td class='line' width='60%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
		        </tr>
	        </table>
	    </td>
	    <td class='line' width='40%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
<%	}//if end%>
</table>
</form>
</body>
</html>
