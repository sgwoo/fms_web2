<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.cus0601.*" %>
<%@ page import="acar.util.*, acar.master_car.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String req_code	= request.getParameter("req_code")==null?"":request.getParameter("req_code");
//	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String jung_dt 	= request.getParameter("jung_dt")==null?"":request.getParameter("jung_dt");
	String pay_dt 	= request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettle(doc_no);
		
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("51", req_code);
		doc_no = doc.getDoc_no();
	}
		
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	String off_id = ""; //�����ڵ��� setting ->�˻�� ���� ����ڰ�  ���� (007410)  - �ϵ�����Ź�۹��� 008411
//	String off_id = "007410"; //�����ڵ��� setting ->�˻�� ���� ����ڰ�  ���� (007410)  - �ϵ�����Ź�۹��� 008411
				
	Vector vt = new Vector();
	if(doc_no.equals("")){
	//	vt = cs_db.getConsignmentNotPayOffList(off_id, req_dt, br_id2);
	}else{
		vt = mc_db.getCarMaintReqDocList2(req_code, pay_dt);
		
		if(vt.size()>0){
			for(int i = 0 ; i < 1 ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				off_id = String.valueOf(ht.get("OFF_ID"));
			//	jung_dt = String.valueOf(ht.get("JUNG_DT"));
				 
			}
		}
	}
	
	int vt_size = vt.size();
	//
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);
	
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	
	long r_total_amt1	= 0;
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+
					"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&from_page="+from_page+"&mode="+mode+"&off_id="+off_id+"&jung_dt="+jung_dt+"";
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
			fm.action = 'cons_req_doc_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	

	function view_cons(cons_no, seq){
		var width 	= 800;
		var height 	= 700;		
		window.open("cons_reg_print.jsp?cons_no="+cons_no+"&seq="+seq+"&step=3", "Print", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}
	
	function view_cons2(cons_no, seq){
		var fm = document.form1;		
		fm.action='cons_reg_step4.jsp?cons_no='+cons_no;		
		fm.target='d_content';
		fm.submit();
	}	
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='car_maint_req_doc_sanction.jsp';		
//			fm.target='i_no';
			fm.submit();
		}									
	}
	
	function msg_send(msg_send_bit){
		var fm = document.form1;
		
		if(confirm('�޽����� �������Ͻðڽ��ϱ�?')){	
			fm.msg_send_bit.value = msg_send_bit;		
			fm.action='car_maint_req_doc_sanction.jsp';		
//			fm.target='i_no';
			fm.submit();
		}						
	}	
	
	
	function updateJungdt(){
		var fm = document.form1;
		
		if(confirm('�������ڸ� �����Ͻðڽ��ϱ�?')){				
			fm.action='car_maint_req_dt_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}						
	}	
	
	
	//�׿�����ǥ��ȸ
	function autodocu_reg(){
		var fm = document.form1;
		
		if(fm.req_code.value == '')	{ alert('û���ڵ尡 �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }		
		if(fm.jung_dt.value == '')	{ alert('�������ڰ� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }	
		if(fm.ven_code.value == '')	{ alert('�׿����ڵ尡 �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }	
		
		if(confirm('�����ޱ���ǥ�� �����Ͻðڽ��ϱ�?')){
			fm.action='car_maint_req_doc_autodocu_reg.jsp';		
			fm.target = 'i_no';
//			fm.target = '_blank';
			fm.submit();		
		}
	}
	
	
	function set_vat_amt(){
		var fm = document.form1;
				
		if (fm.vat.checked == true) { //���Աݾ��̸� 		
			 fm.autodocu_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.r_req_amt.value)) /1.1 );
			 fm.autodocu_v_amt.value 	=parseDecimal(toInt(parseDigit(fm.r_req_amt.value)) - toInt(parseDigit(fm.autodocu_s_amt.value)));	
		} else {		
			 fm.autodocu_s_amt.value 	=parseDecimal( toInt(parseDigit(fm.r_req_amt.value)) );
			 fm.autodocu_v_amt.value 	=parseDecimal( toInt(parseDigit(fm.r_req_amt.value)) *0.1 );
		}			
	}	 
		
	// ��������ǥ �հ�
	function set_add_amt(){
		var fm = document.form1;
		
		fm.autodocu_amt.value 	= parseDecimal( toInt(parseDigit(fm.autodocu_s_amt.value)) + toInt(parseDigit(fm.autodocu_v_amt.value)));		
	}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
<!--<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" viewastext codebase="http://www.meadroid.com/scriptx/smsx.cab#Version=6,3,435,20">-->
</object>
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
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='off_id' 	value='<%=off_id%>'>
  <input type='hidden' name='req_code' 	value='<%=req_code%>'>  
  <input type='hidden' name='doc_bit' 	value='<%=doc_bit%>'>
  <input type='hidden' name='doc_no' 	value='<%=doc_no%>'>
  <input type='hidden' name='size' 		value='<%=vt_size%>'>
  <input type='hidden' name='off_nm' 	value='<%=c61_soBn.getOff_nm()%>'>
  <input type='hidden' name='user_dt1' 		value='<%=doc.getUser_dt1()%>'>
  <input type='hidden' name='msg_send_bit' 	value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=810>
    <tr>
      <td>&lt; �ڵ����˻� ���� ����Ʈ &gt; </td>
    </tr>  
    <tr>
      <td>&nbsp;<%if(mode.equals("doc_settle")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td>
    </tr>  
	<tr>
	  <td>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width="800" class=line>
			  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			  <tr><td class=line2></td></tr>
                <tr>
                  <td width="10%" align='center'>��ü</td>		  
                  <td width="23%" align='center'><%=c61_soBn.getOff_nm()%></td>
                  <td width="10%" align='center'>�ŷ�����</td>
                  <td width="23%" align='center'><%=c61_soBn.getBank()%></td>
                  <td width="10%" align='center'>���¹�ȣ</td>
                  <td align='center'><%=c61_soBn.getAcc_no()%></td>
                </tr>
                <tr>
		          <td align='center'>��������</td>
                  <td align='center'><input type='text' name="jung_dt" value='<%=AddUtil.ChangeDate2(jung_dt)%>' size='10' ></td>
                  <td align='center'>�ѰǼ�</td>
                  <td align='center'><%=vt_size%>��</td>
                  <td align='center'>��û���ݾ�</td>
                  <td align='center'><input type='text' name="req_amt" value='' size='10' class='whitenum' readonly>��</td>
                </tr>
                <tr>
		          <td align='center'></td>
                  <td align='center'> 
                 <% if ( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������ⳳ",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id) || nm_db.getWorkAuthUser("���·������",user_id) ){%>
                  <a href="javascript:updateJungdt();" onMouseOver="window.status=''; return true">[����]</a>
                 <% } %> 
                  </td>
                  <td align='center'>DC�ݾ�</td>
                  <td align='center'><input type='text' name="dc_amt" value='' size='10' class='whitenum' readonly>��</td>
                  <td align='center'><% if ( off_id.equals("007410") ||  off_id.equals("011614")  ) { %>��û���ݾ�(���ް�) <% } else {%>��û���ݾ�<%} %></td>
                  <td align='center'><input type='text' name="r_req_amt" value='' size='10' class='whitenum' readonly>��</td>
                </tr>
              </table>
			</td>
			<td width="110">&nbsp;</td>
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
		<tr><td class=line2></td></tr>
		  <tr valign="middle" align="center"> 
		    <td style="font-size:9pt" width='30' align='center'>����</td>		  
		    <td style="font-size:9pt" width='90' align='center'>�˻�����</td>
		    <td style="font-size:9pt" width='100'align='center'>��ȣ</td>
		    <td style="font-size:9pt" width='85' align='center'>������ȣ</td>
		    <td style="font-size:9pt" width='90' align='center'>����</td>		   
		    <td style="font-size:9pt" width='120' align='center'>�׸�&nbsp;&nbsp;&nbsp;����</td>
		    <td style="font-size:9pt" width='90' align='center'>�˻�ݾ�</td>		
		    <td style="font-size:9pt" width="60" align='center'>����Ÿ�</td>		
	      </tr>
	
<%		   long che_amt = 0;
           float che_f_amt = 0;
           for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String tint_dt = String.valueOf(ht.get("CHE_DT"));
				if(tint_dt.length() >= 8){
					tint_dt = tint_dt.substring(0,8);
				}
				if(tint_dt.length() == 0){
					tint_dt = String.valueOf(ht.get("REG_DT"));
				}%>
		  <tr> 
		    <td style="font-size:9pt" align='center'><%=i+1%><input type='hidden' name='m1_no' value='<%=ht.get("M1_NO")%>'></td>
		    <td style="font-size:9pt" align='center'><%=tint_dt%></td>						
		    <td style="font-size:9pt" align='center'><%=ht.get("FIRM_NM")%></td>
		    <td style="font-size:9pt" align='center'><%=ht.get("CAR_NO")%></td>
		    <td style="font-size:9pt" align='center'><%=ht.get("CAR_NM")%></td>	
		    <td style="font-size:9pt" align='center'><%=ht.get("CHE_TYPE")%>&nbsp;&nbsp;&nbsp;<%=ht.get("GUBUN")%></td>
		    <td style="font-size:9pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CHE_AMT")))%></td>			
		    <td style="font-size:9pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%></td>				
		  </tr>
  <%		
		//  if ( off_id.equals("007410") ||  off_id.equals("011614")  ) {			 
		//	  total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CHE_AMT")));	
		//  } else {
		//	  che_f_amt = ( AddUtil.parseFloat(String.valueOf(ht.get("CHE_AMT"))) / AddUtil.parseFloat("1.1") );
		//	  che_amt = (long)  che_f_amt;
		//	  System.out.println("che_amt="+che_amt);
		//  } 
  
      	  total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CHE_AMT")));	
    
      	
  }%>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>					
					<td>&nbsp;</td>					
					<td>&nbsp;</td>				
					<td>&nbsp;</td>	
					<td>&nbsp;</td>						
					<td style="font-size:9pt" align='right'><%=Util.parseDecimal(total_amt1)%></td>	
					<td>&nbsp;</td>																			
																											
				</tr>		  
	    </table>
	  </td>
	</tr>
	<tr>
		<td align="right">
		  <a href="javascript:print()"><img src=/acar/images/center/button_print.gif border=0 align=absmiddle></a><font color=#CCCCCC>&nbsp;(���μ�TIP : A4, ���ι���)</font>&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
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
            <td width="500" class=line>
			  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			  <tr><td class=line2></td></tr>
                <tr valign="middle" align="center">
                  <td width='30' rowspan="2" align='center'>��<br>��</td>
                  <td width='80' align='center'>������</td>
                  <td width='150' align='center'>�����</td>	
     			  <td width='150' align='center'>����������</td>
     			  <td width='150' align='center'>�ѹ�����</td>
		 
                </tr>
                <tr>
                  <td align='center'></td>				
                  <td align='center'><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><a href="javascript:doc_sanction('1')">����</a><br>&nbsp;<%}else{%><%if(doc.getUser_dt2().equals("")){%><%if(doc.getUser_id1().equals(user_id) || nm_db.getWorkAuthUser("������",user_id)){%><%}%><%}%><%}%></td>
                  <td align='center'><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) ){%><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><br>&nbsp;<%}%><%}%></td>		
                  <td align='center'><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%><%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){%><%if(doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) ){%><a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><br>&nbsp;<%}%><%}%></td>						
					  
                </tr>
              </table>
			</td>
			<td width="510">&nbsp;</td>
          </tr>
        </table>		  
	  </td>	
	</tr>

	<!--�����ޱ���ǥ����-->
	<%		if(!doc.getUser_id1().equals("") && ( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������ⳳ",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id) || nm_db.getWorkAuthUser("���·������",user_id)   ) ){%>
	<tr>
		<td>&nbsp;</td>	
	</tr>
	<tr>
		<td><hr></td>	
	</tr>
    <tr>
      <td>&lt; �����ޱ� �ڵ���ǥ &gt; </td>
    </tr>  
     <%  
     //����,���񼭴� û���ݾ��� ���ް�, �׿ܴ� vat���� �ݾ� 
     if ( off_id.equals("007410") ||  off_id.equals("011614")  ) {
    	 r_total_amt1 = total_amt1 - (total_amt1*5/100);
     } else {
    	 r_total_amt1 = total_amt1;
     }
          
     %>     
    
	<tr>
	  <td>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width="750" class=line>
			  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			  <tr><td class=line2></td></tr>
                <tr>
                  <td width="20%" align='center'>��ǥ����</td>
                  <td width="80%">&nbsp;<input type='text' name='autodocu_dt' value='<%=AddUtil.ChangeDate2(jung_dt)%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  
                   <input type="checkbox" name='vat' value='Y' <% if ( off_id.equals("007410") ||  off_id.equals("009620") ||  off_id.equals("011614") ) { %> <% } else { %>checked<%} %> onClick='javascript:set_vat_amt();'>�ΰ��� ����  
                              
               		  &nbsp;&nbsp;* �׿����ڵ� : <input type='text' name='ven_code' value='<%=c61_soBn.getVen_code()%>'  class='whitetext' >
                  </td>	  
                                 
                </tr>
                <tr>
                  <td width="20%" align='center'>�ݾ�</td>            
                  <td width="80%">
				    &nbsp;���ް� : <input type='text' name='autodocu_s_amt' value='<%=Util.parseDecimal(r_total_amt1)%>' maxlength='12' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_add_amt();'>
					&nbsp;�ΰ��� : <input type='text' name='autodocu_v_amt' value='<%=Util.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(r_total_amt1*0.1)))%>' maxlength='12' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_add_amt();'>
					&nbsp;�հ� : <input type='text' name='autodocu_amt' value='' maxlength='12' size='10' class='num'  readonly>			  
				  </td>
                </tr>				
              </table>
			</td>
			<td width="210">&nbsp;<a href="javascript:autodocu_reg()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_jpbh_mgg.gif border=0 align=absmiddle></a></td>
          </tr>
        </table>		  
	  </td>	
	</tr>		
	<tr>
		<td>�� �׿����� �����ޱ� ��ǥ�� �̹����϶� ó���ϼ���. ��ݿ��忡 �ڵ���ϵ˴ϴ�.</td>	
	</tr>
	<%		}%>	
	<%//}%>	
	<%}%>	
  </table>
  <input type='hidden' name='che_amt' 	value='<%=total_amt1%>'>
 
    
</form>  
<script language='javascript'>
<!--
set_init();

function set_init(){
	var fm = document.form1;		
			//����, ������ ���� �˻�ݾ��� ���ް�
	if (fm.off_id.value == "007410" ||  fm.off_id.value == "011614"  ){
		fm.req_amt.value = '<%=Util.parseDecimal(total_amt1)%>';
		fm.dc_amt.value = '<%=Util.parseDecimal(total_amt1*0.05)%>';
		fm.r_req_amt.value = '<%=Util.parseDecimal(total_amt1 - (total_amt1*0.05 ))%>';
		
		fm.autodocu_s_amt.value 	=parseDecimal( toInt(parseDigit(fm.r_req_amt.value)) );
		fm.autodocu_v_amt.value 	=parseDecimal( toInt(parseDigit(fm.r_req_amt.value)) *0.1 );		 
	} else{		
		fm.req_amt.value = '<%=Util.parseDecimal(total_amt1)%>'	      
		fm.dc_amt.value = '0';
		fm.r_req_amt.value = '<%=Util.parseDecimal(total_amt1)%>';	
		
		fm.autodocu_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.r_req_amt.value)) /1.1 );
		fm.autodocu_v_amt.value 	=parseDecimal(toInt(parseDigit(fm.r_req_amt.value)) - toInt(parseDigit(fm.autodocu_s_amt.value)));			 				
	}
			
	fm.autodocu_amt.value 	= parseDecimal( toInt(parseDigit(fm.autodocu_s_amt.value)) + toInt(parseDigit(fm.autodocu_v_amt.value)));		
}
	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">
function onprint(){
factory.printing.header 		= ""; //��������� �μ�
factory.printing.footer 		= ""; //�������ϴ� �μ�
factory.printing.portrait 		= false; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin 	= 10; //��������   
factory.printing.rightMargin 	= 10; //��������
factory.printing.topMargin 		= 10; //��ܿ���    
factory.printing.bottomMargin 	= 10; //�ϴܿ���
//factory.printing.Print(false, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>
