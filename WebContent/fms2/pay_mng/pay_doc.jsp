<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String doc_code	= request.getParameter("doc_code")==null?"":request.getParameter("doc_code");
	String p_est_dt	= request.getParameter("p_est_dt")==null?"":request.getParameter("p_est_dt");
	String p_est_dt2= request.getParameter("p_est_dt2")==null?"":request.getParameter("p_est_dt2");
	String p_req_dt	= request.getParameter("p_req_dt")==null?"":request.getParameter("p_req_dt");
	String p_gubun	= request.getParameter("p_gubun")==null?"":request.getParameter("p_gubun");
	String p_br_id	= request.getParameter("p_br_id")==null?"":request.getParameter("p_br_id");	
	String doc_bit	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = pm_db.getPayDocList(doc_code, p_est_dt, p_gubun, p_br_id, doc_no);
	int vt_size = vt.size();
	
	
	Vector vt3 = pm_db.getPayDocAmtStat(doc_code, p_est_dt, p_gubun, p_br_id, doc_no);
	int vt_size3 = vt3.size();
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("") && !doc_code.equals("")){
		doc = d_db.getDocSettleCommi("31", doc_code);
	}
	
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	if(doc_no.equals("")){
		user_bean 	= umd.getUsersBean(user_id);
	}
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;
	long total_amt17 = 0;
	
	int s1 = 0;
	int b1 = 0;
	int d1 = 0;
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+
				   	"";
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����Ʈ
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'pay_d_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='pay_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	function doc_sanction_non(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		fm.non_id3.value = '1';
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='pay_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}				
	}
	//����
	function view_pay_ledger(reg_end, p_gubun, reqseq, i_seq, amt){
		window.open("pay_upd_step2.jsp<%=valus%>&mode=view&reqseq="+reqseq, "VIEW_PAY_LEDGER", "left=150, top=150, width=900, height=700, scrollbars=yes");			
	}	
		
	function view_pay_ledger_doc(reqseq, p_gubun, p_cd1, p_cd2, p_cd3, p_cd4, p_cd5, p_st1, p_st4, i_cnt){
		var w_width  = 850;
		var w_height = 650;
		var url_etc = '';
		
		//�������
		if(p_gubun == '99'){
			w_width  = 900;
			w_height = 400;
			window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");				
		//��ȸ���
		}else{		
			if(i_cnt == '1'){
				if(p_gubun == '01'){
					w_width  = 900;
					w_height = 700;
					window.open("/fms2/car_pur/pur_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '02'){
					w_width  = 900;
					w_height = 700;
					if(p_cd3 == '7'){
						window.open("/fms2/commi/suc_commi_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}else{
						window.open("/fms2/commi/commi_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}
				}else if(p_gubun == '04'){
					w_width  = 850;
					w_height = 800;
					if(p_st4=='����'){
						var lend_id = p_cd1.substring(0,4);
						var rtn_seq = p_cd1.substring(4);
						window.open("/acar/con_debt/debt_c_bank2.jsp<%=valus%>&mode=view&lend_id="+lend_id+"&rtn_seq="+rtn_seq+"&alt_tm="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}else{
							if(p_cd4 != '') url_etc = '&m_id='+p_cd3+'&l_cd='+p_cd4;
							window.open("/acar/con_debt/debt_c.jsp<%=valus%>&mode=view&c_id="+p_cd1+"&alt_tm="+p_cd2+url_etc, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
						}
				}else if(p_gubun == '11'){
					if(p_cd1 == 'null' || p_cd1==p_st1){
						w_width  = 900;
						w_height = 400;
						window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");							
					}else{					
						w_width  = 900;
						w_height = 700;			
						if(p_cd5 != '') url_etc = '&rent_mng_id='+p_cd4+'&rent_l_cd='+p_cd5;			
						window.open("/acar/cus_reg/serv_reg.jsp<%=valus%>&mode=view&car_mng_id="+p_cd1+"&serv_id="+p_cd2+url_etc, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}
				}else if(p_gubun == '21'){
					w_width  = 1000;
					w_height = 800;
					window.open("/acar/fine_mng/fine_mng_frame.jsp<%=valus%>&mode=view&car_mng_id="+p_cd1+"&seq_no="+p_cd2+"&rent_mng_id="+p_cd3+"&rent_l_cd="+p_cd4, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '31'){
					w_width  = 1000;
					w_height = 800;
					window.open("/fms2/cls_cont/lc_cls_u3.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '35'){
					w_width  = 1100;
					w_height = 600;
					window.open("/fms2/lc_rent/lc_c_c_suc_commi.jsp<%=valus%>&mode=pay_view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}else if(p_gubun == '07' || p_gubun == '08'){
					w_width  = 1000;
					w_height = 500;					
					window.open("pay_lists.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");
				}else{		
					w_width  = 900;
					w_height = 400;
					window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
				}
			}else{
				if(p_gubun == '07' || p_gubun == '08'){
					w_width  = 1000;
					w_height = 500;					
					window.open("pay_lists.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");
				}else{		
					w_width  = 1000;
					w_height = 500;
					window.open("pay_file_lists.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");
				}	
			}
		}
	}
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>      
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='doc_code' 	value='<%=doc_code%>'>
  <input type='hidden' name='p_gubun' 	value='<%=p_gubun%>'>  
  <input type='hidden' name='doc_no' 	value='<%=doc_no%>'>    
  <input type='hidden' name='doc_bit' 	value='<%=doc_bit%>'>  
  <input type='hidden' name='size' 		value='<%=vt_size%>'>    
  <input type='hidden' name='non_id3'	value=''>      


<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td><< �����ȹ >></td>
    </tr>  
    <tr>
        <td>&nbsp;<%if(mode.equals("doc_settle")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='30' class='title'>����</td>
					<td width="40" class='title'>�ߺ�<br>����</td>	
        		    <td width="40" class='title'>���<br>���</td>
        		    <td width="40" class='title'>���<br>�ð�</td>					
					<td width="80" class='title'>�ŷ�����</td>					
        		    <td width="60" class='title'>��ݹ��</td>
        		    <td width='100' class='title'>����׸�</td>
        		    <td width="150" class='title'>����ó</td>					
               		<td width='100' class='title'>�ݾ�</td>
               		<td width='200' class='title'>����</td>        			
        		    <td width="80" class='title'>�������</td>
        		    <td width="60" class='title'>�����</td>
       		    </tr>		
		  <%
				for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		  %>
		        <tr>
        			<td align='center'><%=i+1%><input type='hidden' name='reqseq' value='<%=ht.get("REQSEQ")%>'></td>
        		    <td align='center'>
		  			  <%if(String.valueOf(ht.get("P_GUBUN")).equals("01") || String.valueOf(ht.get("P_GUBUN")).equals("06") || String.valueOf(ht.get("P_GUBUN")).equals("02") || String.valueOf(ht.get("P_GUBUN")).equals("04") || String.valueOf(ht.get("P_GUBUN")).equals("11") || String.valueOf(ht.get("P_GUBUN")).equals("12") || String.valueOf(ht.get("P_GUBUN")).equals("13") || String.valueOf(ht.get("P_GUBUN")).equals("21") || String.valueOf(ht.get("P_GUBUN")).equals("31") || String.valueOf(ht.get("P_GUBUN")).equals("37")){//�ڵ������,�Һα�,���·�%>
		    			<a href="javascript:view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">����</a>
		  			  <%}else if(String.valueOf(ht.get("P_GUBUN")).equals("99") && !String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		   			   	<a href="javascript:view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=String.valueOf(ht.get("FILE_CNT"))%>��</a>		  
		  			  <%}else if(String.valueOf(ht.get("P_GUBUN")).equals("99") && String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		    			<a href="javascript:view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">���</a>		  
		  			  <%}else{%>
					  <%	if(String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
					    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">���</a>
					  <%	}else{%>
					    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=String.valueOf(ht.get("FILE_CNT"))%>��</a>
					  <%	}%>
		  			  <%}%>					
					</td>
        		    <td align='center'><%=ht.get("REG_ST_NM")%></td>
		            <td align='center'>
					  <%if(String.valueOf(ht.get("AT_ONCE")).equals("Y")){%>
					  <font color=red>���</font>
					  <%}else{%>
					  ����
					  <%}%>
				    </td>									
        			<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_EST_DT")))%></td>					
        		    <td align='center'><%=ht.get("WAY_NM")%></td>
        		    <td align='center'><a href="javascript:view_pay_ledger('<%=ht.get("REG_END")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("REQSEQ")%>','<%=ht.get("I_SEQ")%>','<%=ht.get("AMT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=ht.get("GUBUN_NM")%></a></td>					
		  			<td align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 12)%></span>
		  			<%if(!String.valueOf(ht.get("OFF_NM")).equals(String.valueOf(ht.get("VEN_NAME")))){%>
		  			<br>
		  			(<%=ht.get("VEN_NAME")%>)
		  			<%}%>
		  			</td>					
		  			<td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
		  			<td >&nbsp;<%=ht.get("P_CONT")%></td>
		  			<td align='center'><%=ht.get("REG_DT_NM")%></td>
		  			<td align='center'><%=ht.get("REG_NM")%></td>		  		  
       			</tr>
		  <%		total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("WAY_NM")).equals("����")) 		total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("WAY_NM")).equals("����ī��")) 	total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("WAY_NM")).equals("�ĺ�ī��")) 	total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("WAY_NM")).equals("�ڵ���ü")) 	total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
					if(String.valueOf(ht.get("WAY_NM")).equals("ī���Һ�")) 	total_amt17 = total_amt17 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
		 		}%>
		        <tr>
        		    <td colspan="8" class=title>�հ�</td>
        		    <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>		
        		    <td class=title>&nbsp;</td>					
        		    <td class=title>&nbsp;</td>					
        		    <td class=title>&nbsp;</td>																									
       		    </tr>
		    </table>
	    </td>
    </tr>  		    	
	<tr>
		<td align="right">
		  <a href="javascript:print()"><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a><font color=#CCCCCC>&nbsp;(���μ�TIP : A3, ���ι���)</font>&nbsp;&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>			
	<tr>
		<td>&nbsp;</td>	
	</tr>	
	<%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){%>	
	<tr>
      <td>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>		  
        			<td class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        			        <tr>
		                        <td class=line2 style='height:1'></td>
		                    </tr>
                            <tr>
                                <td width='140' align="center" class=title>û������</td>
                                <td colspan="14">&nbsp;<input type='text' size='11' name='req_dt' maxlength='10' class='whitetext' value='<%=p_req_dt%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                            </tr>
							<% if(p_est_dt2.equals("")) p_est_dt2 = p_req_dt; %>
                            <tr>
                                <td width='140' align="center" class=title>���⿹������</td>
                                <td colspan="14">&nbsp;<input type='text' size='11' name='est_dt' maxlength='10' class='whitetext' value='<%=p_est_dt2%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                            </tr>
                            <tr>
                                <td width='140' rowspan="2" class=title>����׸�</td>
                                <td colspan="2" class=title>�Ұ�</td>
                                <td colspan="2" class=title>��������</td>
                                <td colspan="2" class=title>�ڵ���ü</td>
                                <td colspan="2" class=title>������ü</td>
                                <td colspan="2" class=title>����ī��</td>
                                <td colspan="2" class=title>�ĺ�ī��</td>
                                <td colspan="2" class=title>ī���Һ�</td>
                            </tr>
                            <tr>
                              <td width='50' class=title>�Ǽ�</td>
                              <td width='100' class=title>�ݾ�</td>
                              <td width='50' class=title>�Ǽ�</td>
                              <td width='100' class=title>�ݾ�</td>
                              <td width='50' class=title>�Ǽ�</td>
                              <td width='100' class=title>�ݾ�</td>
                              <td width='50' class=title>�Ǽ�</td>
                              <td width='100' class=title>�ݾ�</td>
                              <td width='50' class=title>�Ǽ�</td>
                              <td width='100' class=title>�ݾ�</td>
                              <td width='50' class=title>�Ǽ�</td>
                              <td width='100' class=title>�ݾ�</td>
                              <td width='50' class=title>�Ǽ�</td>
                              <td width='100' class=title>�ݾ�</td>
                            </tr>
							<%	long total_amt[] = new long[14];
								for(int i = 0 ; i < vt_size3 ; i++){
									Hashtable ht = (Hashtable)vt3.elementAt(i);
									
									total_amt[6] 		+= AddUtil.parseLong(String.valueOf(ht.get("TOT_CNT")));
									total_amt[0] 		+= AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
									total_amt[1] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
									total_amt[2] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
									total_amt[3] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
									total_amt[4] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
									total_amt[5] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
									total_amt[12] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
									
									
									total_amt[7] 		+= AddUtil.parseLong(String.valueOf(ht.get("CNT1")));
									total_amt[8] 		+= AddUtil.parseLong(String.valueOf(ht.get("CNT2")));
									total_amt[9] 		+= AddUtil.parseLong(String.valueOf(ht.get("CNT3")));
									total_amt[10] 		+= AddUtil.parseLong(String.valueOf(ht.get("CNT4")));
									total_amt[11] 		+= AddUtil.parseLong(String.valueOf(ht.get("CNT5")));
									total_amt[13] 		+= AddUtil.parseLong(String.valueOf(ht.get("CNT7")));
							%>
                            <tr >
                                <td align='center'><%=ht.get("GUBUN_NM")%><%//=ht.get("P_ST2")%></td>
                                <td align='center'><%=Util.parseDecimal(String.valueOf(ht.get("TOT_CNT")))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("TOT_AMT")))%></td>
                                <td align='center'><%=Util.parseDecimal(String.valueOf(ht.get("CNT1")))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
                                <td align='center'><%=Util.parseDecimal(String.valueOf(ht.get("CNT3")))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
                                <td align='center'><%=Util.parseDecimal(String.valueOf(ht.get("CNT2")))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>								
                                <td align='center'><%=Util.parseDecimal(String.valueOf(ht.get("CNT4")))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></td>
                                <td align='center'><%=Util.parseDecimal(String.valueOf(ht.get("CNT5")))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%></td>
                                <td align='center'><%=Util.parseDecimal(String.valueOf(ht.get("CNT7")))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT7")))%></td>
                            </tr>
							<%	}%>
                            <tr>
                                <td align="center" class=title>�հ�</td>
                                <td class=title ><%=AddUtil.parseDecimalLong(total_amt[6])%></td>
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt[0])%></td>
                                <td class=title ><%=AddUtil.parseDecimalLong(total_amt[7])%></td>								
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt[1])%></td>
                                <td class=title ><%=AddUtil.parseDecimalLong(total_amt[9])%></td>
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt[3])%></td>								
                                <td class=title ><%=AddUtil.parseDecimalLong(total_amt[8])%></td>
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt[2])%></td>								
                                <td class=title ><%=AddUtil.parseDecimalLong(total_amt[10])%></td>
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt[4])%></td>
                                <td class=title ><%=AddUtil.parseDecimalLong(total_amt[11])%></td>
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt[5])%></td>
                                <td class=title ><%=AddUtil.parseDecimalLong(total_amt[12])%></td>
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt[13])%></td>
                            </tr>
                        </table>			
   			      </td>	
                </tr>	
            </table>		  
			</td>	
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>			
	<tr>
	    <td>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>		  
        			<td width="240">&nbsp;   			      </td>	
        			<td width="80">&nbsp;</td>							  
                    <td width="590" class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr valign="middle" align="center">
                                <td width='30' rowspan="2" class=title>��<br>��</td>
                                <td width='140' class=title>������</td>
                                <td width='140' class=title>�����</td>
                                <td width='140' class=title>������</td>
                                <td width='140' class=title>�ѹ�����</td>				  
                            </tr>
                            <tr>
                                <td align='center'>&nbsp;<br>&nbsp;<br>&nbsp;<br><%=user_bean.getBr_nm()%><br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;</td>
                                <td align='center'>&nbsp;<br>&nbsp;<br><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%>&nbsp;<br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><a href="javascript:doc_sanction('1')"><img src=/acar/images/center/button_in_gj.gif border=0 align=absmiddle></a><%}%><br>&nbsp;<br>&nbsp;<br>&nbsp;</td>
                                <td align='center'>&nbsp;<br>&nbsp;<br><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%>&nbsp;<br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("") && !doc.getUser_id2().equals("XXXXXX") && !doc.getUser_id2().equals("")){%><%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id)){%><a href="javascript:doc_sanction('2')"><img src=/acar/images/center/button_in_gj.gif border=0 align=absmiddle></a><%}%><%}%><%if(!user_bean.getBr_id().equals("S1") && !user_bean.getBr_id().equals("S2") && !user_bean.getBr_id().equals("I1") && !user_bean.getBr_id().equals("K3") && !user_bean.getBr_id().equals("S3") && !user_bean.getBr_id().equals("S4") && !user_bean.getBr_id().equals("S5") && !user_bean.getBr_id().equals("S6") && doc.getUser_id2().equals("XXXXXX")){%>�����߰���<%}%><br>&nbsp;<br>&nbsp;<br>&nbsp;</td>				
                                <td align='center'>&nbsp;<br>&nbsp;<br><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%>&nbsp;<br><%=doc.getUser_dt3()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt3().equals("") && !doc.getUser_id3().equals("XXXXXX") && !doc.getUser_id3().equals("")){%><%if(!doc.getUser_dt2().equals("") || doc.getUser_id2().equals("XXXXXX")){%><%if(doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id)){%><a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><br>&nbsp;<%}%><%}%><%}%>
								<%if(!doc.getDoc_step().equals("3") && doc.getUser_dt3().equals("")){%><%if(nm_db.getWorkAuthUser("������",user_id)  || nm_db.getWorkAuthUser("�Աݴ��",user_id) || nm_db.getWorkAuthUser("��������ȸ�������",user_id) || nm_db.getWorkAuthUser("�������",user_id)){%><br>&nbsp;<br>&nbsp;<a href="javascript:doc_sanction_non('3')"><img src="/acar/images/center/button_gj_sh.gif" align="absmiddle" border="0"></a><%}%><%}%>
								<br>&nbsp;</td>
                            </tr>
                        </table>
        			</td>
        			<td width="70">&nbsp;</td>
                </tr>	
            </table>		  
	    </td>	
	</tr>
	<%}%>			  
</table>
  <input type='hidden' name='size' value='<%=vt_size%>'>  
</form>  
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
