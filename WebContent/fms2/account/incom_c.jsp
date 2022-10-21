<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.incom.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.fee.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
		
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq			= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	
	String s_kd 	= request.getParameter("s_kd")==null? "1":request.getParameter("s_kd");
	String s_kd2 	= request.getParameter("s_kd2")==null? "":request.getParameter("s_kd2");
	String t_wd2 	= request.getParameter("t_wd2")==null? "" :request.getParameter("t_wd2");
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
	//�Աݰŷ����� ����
	IncomBean base = in_db.getIncomClientBase(incom_dt, incom_seq);
	String p_gubun = base.getP_gubun();
	 
	//�Աݰŷ����� ����
	IncomEtcBean in_etc = in_db.getIncomIncomEtcBase(incom_dt, incom_seq);
	
	String value[] = new String[2];
	StringTokenizer st = new StringTokenizer(base.getBank_nm(),":");
	int s=0; 
	while(st.hasMoreTokens()){
		value[s] = st.nextToken();
		s++;
	}
		
	long total_amt  = 0;
	long total_r_amt = 0;
	
	
	Vector vt = in_db.getIncomItemList(incom_dt, incom_seq);
	int settle_size = vt.size();
	
	long total_c_amt  = 0;
	long total_t_amt = 0;
				
	Vector vt_c = in_db.getIncomItemCardList(incom_dt, incom_seq);
	int c_size = vt_c.size();  
	
	
	Vector inss =  in_db.getIncomInsList(incom_dt, incom_seq);		
	int ins_size = inss.size(); 
  	
  	long ins_amt = 0;  	
  	
  	String dly_pubcode = "";	 	
 
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function go_list(){
      	var fm = document.form1;
	
		fm.target = 'd_content';
		fm.action = '<%=from_page%>';
		fm.submit();    
	}

	function view_agnt_email(gubun, tm, rent_st, ext_id,  pay_amt, pubcode, rent_mng_id , rent_l_cd, pay_dt, seqid)
	{
		var fm = document.form1;
		

		if(pubcode == ''){		
				var SUBWIN="incom_payebill_u.jsp?ext_id="+ext_id+"&tm="+tm+"&rent_st=" + rent_st +  "&seqid="+ seqid+ "&rent_mng_id="+ rent_mng_id + "&rent_l_cd=" + rent_l_cd +"&trusbill_gubun="+gubun+"&pay_amt="+pay_amt+"&pay_dt=" + pay_dt;
				window.open(SUBWIN, "agnt_email", "left=100, top=50, width=700, height=350, resizable=yes, scrollbars=yes, status=yes");
				
		}else{
			viewDepoSlip(pubcode);
		}			
	}
	
	
	function  viewDepoSlip(depoSlippubCode){
	
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var depoSlip = window.open("about:blank", "depoSlip", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=750px, height=700px");
		document.depoSlipListForm.action="https://www.trusbill.or.kr/jsp/directDepo/DepoSlipViewIndex.jsp";
		document.depoSlipListForm.method="post";
		document.depoSlipListForm.depoSlippubCode.value=depoSlippubCode;
		document.depoSlipListForm.docType.value="P"; 	//�Ա�ǥ
		document.depoSlipListForm.userType.value="S"; 	// S=�������� ó��ȭ��, R= �޴��� ó��ȭ��
		document.depoSlipListForm.target="depoSlip";
		document.depoSlipListForm.submit();
		document.depoSlipListForm.target="_self";
		document.depoSlipListForm.depoSlippubCode.value="";
		depoSlip.focus();
		return;
	}

		//���
	function upd_incom()
	{
		var fm = document.form1;
		
		if (toInt(parseDigit(fm.in_amt.value)) < 1 ) {
		 	 alert('�ݾ��� Ȯ���ϼ���.');
			 return;
		}	
						
		if(confirm('�ݾ׼����Ͻðڽ��ϱ�?'))
		{		
			fm.target = 'i_no';
			fm.action = 'incom_reg_step2_upd_a.jsp?gubun=incom_c';
			fm.submit();
		}		
	
	}
	
			//ī��� ����
	function upd_card()
	{
		var fm = document.form1;
		
		if(fm.card_cd == ""){ alert("ī��縦 �����ϼ���!!."); return;}
								
		if(confirm('�����Ͻðڽ��ϱ�?'))
		{		
			fm.target = 'i_no';
			fm.action = 'incom_reg_step2_upd2_a.jsp?gubun=incom_c';
			fm.submit();
		}		
	
	}


		//����
	function go_del()
	{
		var fm = document.form1;
	
		
		if(confirm('����ó���Ͻðڽ��ϱ�?'))
		{		
			fm.target = 'i_no';
			fm.action = 'incom_reg_step2_del_a.jsp?gubun=card';
			fm.submit();
		}				
	
	}
	
	function save()
	{
		var fm = document.form1;	
		
		if(confirm('��ǥ������Ͻðڽ��ϱ�?'))
		{		
			fm.target = 'i_no';			
			fm.action = 'incom_re_autodocu_a.jsp'
			fm.submit();
		}	
		
	}	
//-->
</script> 

</head>
<body leftmargin="15">
<form name="depoSlipListForm" method="get">
	<input type="hidden" name="depoSlippubCode" >
	<input type="hidden" name="docType" >
	<input type="hidden" name="userType" >
</form>

<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
  <input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
  <input type='hidden' name='dt' 	value='<%=dt%>'>  
  <input type='hidden' name='ref_dt1' 	value='<%=ref_dt1%>'>  
  <input type='hidden' name='ref_dt2' 	value='<%=ref_dt2%>'>  
  <input type='hidden' name='s_kd2'  	value='<%=s_kd2%>'>
  <input type='hidden' name='t_wd2' 	value='<%=t_wd2%>'>
  <input type='hidden' name='s_kd' 	value='<%=s_kd%>'>
  <input type='hidden' name='bank_code2' 	value='<%=value[0]%>'>
  <input type='hidden' name='deposit_no2' 	value='<%=base.getBank_no()%>'>
  <input type='hidden' name='bank_name' 	value='<%=value[1]%>'>  
  		

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
   <tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>
						�Ա�ó�� ���� </span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr> 
    
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
         
                <tr> 
                    <td class=title width=13%>�Ա�����</td>
                    <td width=37%>&nbsp;<%=base.getIncom_dt()%> &nbsp;&nbsp;&nbsp;<%=base.getRow_id()%>
                    </td>
                    <td class=title width=10%>�Ա��Ѿ�</td>
                    <td width=40%>&nbsp;
                    	<input type='text' name="in_amt" value='<%=AddUtil.parseDecimalLong(base.getIncom_amt())%>' size="12" class='num' >��
                    	 <% if ( base.getRemark().equals("CMS")) { %>&nbsp;<a href="javascript:upd_incom()"><img src="/acar/images/center/button_modify.gif" align=absmiddle border="0"></a><% } %>
                    	 
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=13%>����(ī���)</td>
        <% if ( base.getIp_method().equals("1")) { %>                 
                    <td width=37%>&nbsp;<%=value[1]%></td>		
        <% } else if ( base.getIp_method().equals("2")) { %>                 
                    <td width=37%>&nbsp;
            <select name="card_cd" >
                      	<option value='1' <%if(base.getCard_cd().equals("1")) out.println("selected");%>>BC</option>
		        <option value='2' <%if(base.getCard_cd().equals("2")) out.println("selected");%>>����</option>
		        <option value='3' <%if(base.getCard_cd().equals("3")) out.println("selected");%>>����</option>
		        <option value='4' <%if(base.getCard_cd().equals("4")) out.println("selected");%>>�ϳ�</option>
		        <option value='5' <%if(base.getCard_cd().equals("5")) out.println("selected");%>>�Ե�</option>
		        <option value='6' <%if(base.getCard_cd().equals("6")) out.println("selected");%>>����</option>
		        <option value='7' <%if(base.getCard_cd().equals("7")) out.println("selected");%>>�Ｚ</option>
		        <option value='8' <%if(base.getCard_cd().equals("8")) out.println("selected");%>>��Ƽ</option>
		        <option value='9' <%if(base.getCard_cd().equals("9")) out.println("selected");%>>KCP</option>		
		         <option value='12' <%if(base.getCard_cd().equals("12")) out.println("selected");%>>���̿�</option>		                                  
		        <option value='11' <%if(base.getCard_cd().equals("11")) out.println("selected");%>>���̽�</option>	
		        <option value='13' <%if(base.getCard_cd().equals("13")) out.println("selected");%>>�̳�����</option>		 	                              
              </select> &nbsp;&nbsp;<a href="javascript:upd_card()"><img src="/acar/images/center/button_modify.gif" align=absmiddle border="0"></a> </td>	            
        <% } else  { %>                 
                    <td width=37%>&nbsp;</td>	    
        <% } %>                    			  
                    <td class=title width=13%>����(ī��)��ȣ</td>
        <% if ( base.getIp_method().equals("1")) { %>            
             	    <td width=40%>&nbsp;<%=base.getBank_no()%></td>        
        <% } else if ( base.getIp_method().equals("2")) { %>            
             	    <td width=40%>&nbsp;<%=base.getCard_no()%></td>                
        <% } else  { %>            
             	    <td width=40%>&nbsp;</td>             
        <% } %>			
                </tr>		  	  
                <tr> 
                    <td class=title width=13%>����</td>
                    <td width=37%>&nbsp;<%=base.getRemark()%></td>
                    <td class=title width=10%>�ŷ���</td>
                    <td width=40%>&nbsp;<%=base.getBank_office()%></td>
                </tr>		  
    		  
            </table>
	    </td>
    </tr>  
         	
    <tr>
        <td>&nbsp;</td>
    </tr> 	

	<tr id=tr_acct1 style="display:<%if( !p_gubun.equals("4") ){%>''<%}else{%>none<%}%>"> 
	    	  	
        <td>
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>	
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������&nbsp;</span></td>
    		    </tr>
    		    <tr>
                    <td class=line2></td>
                </tr>
    		    <tr>
    		 	    <td class=line> 
        		        <table border="0" cellspacing="1" cellpadding='0' width=100%>
        		            <tr> 
            		            <td class=title width=13%>��������</td>
            		            <td colspan=3 >&nbsp; 	                
            		                <input type="radio" name="pay_gur" value="0" <% if(base.getPay_gur().equals("0")) out.print("checked"); %> disabled >����
            		    			<input type="radio" name="pay_gur" value="1" <% if(base.getPay_gur().equals("1")) out.print("checked"); %> disabled >���뺸����
            		    	    	<input type="radio" name="pay_gur" value="2" <% if(base.getPay_gur().equals("2")) out.print("checked"); %> disabled >��������
            		      			<input type="radio" name="pay_gur" value="3" <% if(base.getPay_gur().equals("3")) out.print("checked"); %> disabled >ä���߽� 
            		      			<input type="radio" name="pay_gur" value="4" <% if(base.getPay_gur().equals("4")) out.print("checked"); %> disabled >��Ÿ
            		      		</td>				
        		            </tr>		  
        		            <tr> 
            		            <td class=title width=13%>��ȣ/����</td>
            		            <td width=37%>&nbsp;
            					  <input type='text' name='pay_gur_nm' size='40' class='text' value="<%=base.getPay_gur_nm()%>" readonly >
            					</td>					  
            		            <td class=title width=13%>����/����</td>
            		            <td width=40%>&nbsp;
            					  <input type='text' name='pay_gur_rel' size='40' class='text'  value="<%=base.getPay_gur_rel()%>" readonly >
            					</td>
        		            </tr>		  
        		        </table>
    			    </td>
    		    </tr>
    		    <tr>
    		        <td></td>
    		    </tr>
    			<tr>
    			    <td style='height:1; background-color=dddddd;'></td>
    			</tr>
     	        <tr>
    		        <td></td>
    		    </tr>
        	</table>
	    </td>  	
    </tr>
   
	<tr id=tr_acct21 style="display:<%if( !p_gubun.equals("4") ){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                 	<td class="title" width='4%'>����</td>
                    <td class="title" width='17%'>��ȣ/����û��</td>
                    <td class="title" width='11%'>������ȣ</td>
                    <td class="title" width='21%'>����/����ȣ</td>					
                    <td class="title" width='4%'>ȸ��</td>
                    <td class="title" width='12%'>����</td>					
                    <td class="title" width='9%'>�Աݿ�����</td>
                    <td class="title" width='11%'>�����ݾ�</td>
                    <td class="title" width='11%'>�Ա�ó���ݾ�</td>                  
               </tr>
               
          
		<%	if( settle_size > 0){
				    for(int i = 0 ; i <settle_size ; i++){
							Hashtable fee_scd = (Hashtable)vt.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(fee_scd.get("EST_AMT")));
							total_r_amt 	= total_r_amt + Long.parseLong(String.valueOf(fee_scd.get("PAY_AMT")));
							
							if( fee_scd.get("TM1_NM").equals("��ü����") ){							  
								dly_pubcode = in_db.getPayEbillDly(String.valueOf(fee_scd.get("RENT_MNG_ID")), String.valueOf(fee_scd.get("RENT_L_CD")), incom_dt);
						    } else if( fee_scd.get("TM1_NM").equals("��å��") ) {
						   		dly_pubcode = in_db.getPayEbillScdExt(String.valueOf(fee_scd.get("RENT_MNG_ID")), String.valueOf(fee_scd.get("RENT_L_CD")), String.valueOf(fee_scd.get("SEQID")) , "3" , incom_dt);
						    } else if( fee_scd.get("TM1_NM").equals("���������") ) {
						   		dly_pubcode = in_db.getPayEbillExt(String.valueOf(fee_scd.get("RENT_MNG_ID")), String.valueOf(fee_scd.get("RENT_L_CD")), incom_dt);
						    } else if( fee_scd.get("TM1_NM").equals("�°������") ) {
						 	    dly_pubcode = in_db.getPayEbillScdExt(String.valueOf(fee_scd.get("RENT_MNG_ID")), String.valueOf(fee_scd.get("RENT_L_CD")), String.valueOf(fee_scd.get("SEQID")), "5" , incom_dt);						  	
						    } else if( fee_scd.get("TM1_NM").equals("������") ) {
						   		dly_pubcode = in_db.getPayEbillScdExt(String.valueOf(fee_scd.get("RENT_MNG_ID")), String.valueOf(fee_scd.get("RENT_L_CD")), String.valueOf(fee_scd.get("SEQID")), "0" , incom_dt);
						    }
%>			
                <tr>
                    <td align="center"><%=i+1%></td>		
                    <td align="center"><%=fee_scd.get("FIRM_NM")%></td>		
                    <td align="center"><%=fee_scd.get("CAR_NO")%></td>
                    <td align="center"><%=fee_scd.get("CAR_NM")%>&nbsp;<%=fee_scd.get("RENT_L_CD")%>&nbsp;<%=fee_scd.get("RENT_S_CD")%></td>					
                    <td align="center"><%=fee_scd.get("TM")%></td>
                    <td align="center"><%=fee_scd.get("TM1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(fee_scd.get("EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' readonly  class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("EST_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' readonly class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("PAY_AMT")))%>'>��
                    <%if( fee_scd.get("TM1_NM").equals("��ü����") ){%>
			 	   <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	     <a href="javascript:view_agnt_email('dly', '', '', '',  '<%=fee_scd.get("PAY_AMT")%>', '<%=dly_pubcode%>', '<%=fee_scd.get("RENT_MNG_ID")%>', '<%=fee_scd.get("RENT_L_CD")%>', '<%=incom_dt%>', '')"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>
			  	   <% } %>
			       <%}%>  
			       <%if( fee_scd.get("TM1_NM").equals("��å��") ){%>
			 	   <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	     <a href="javascript:view_agnt_email('car_ja','<%=fee_scd.get("TM")%>', '<%=fee_scd.get("RENT_ST")%>', '<%=fee_scd.get("TM2")%>' , '<%=fee_scd.get("PAY_AMT")%>', '<%=dly_pubcode%>', '<%=fee_scd.get("RENT_MNG_ID")%>', '<%=fee_scd.get("RENT_L_CD")%>', '<%=incom_dt%>', '<%=fee_scd.get("SEQID")%>')"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>
			  	   <% } %>
			       <%}%>  
			       <%if( fee_scd.get("TM1_NM").equals("���������") ){%>
			 	   <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	     <a href="javascript:view_agnt_email('ext', '','', '', '<%=fee_scd.get("PAY_AMT")%>', '<%=dly_pubcode%>', '<%=fee_scd.get("RENT_MNG_ID")%>', '<%=fee_scd.get("RENT_L_CD")%>', '<%=incom_dt%>', '')"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>
			  	   <% } %>
			       <%}%>  
			       <%if( fee_scd.get("TM1_NM").equals("�°������") ){%>
			 	   <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	     <a href="javascript:view_agnt_email('commi', '<%=fee_scd.get("TM")%>','<%=fee_scd.get("RENT_ST")%>', '', '<%=fee_scd.get("PAY_AMT")%>', '<%=dly_pubcode%>', '<%=fee_scd.get("RENT_MNG_ID")%>', '<%=fee_scd.get("RENT_L_CD")%>', '<%=incom_dt%>', '<%=fee_scd.get("SEQID")%>')"><!-- <img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0><--></a>
			  	   <% } %>
			       <%}%>  
			       <%if( fee_scd.get("TM1_NM").equals("������") ){%>
			 	   <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>     
			  	     <a href="javascript:view_agnt_email('grt', '<%=fee_scd.get("TM")%>','<%=fee_scd.get("RENT_ST")%>', '', '<%=fee_scd.get("PAY_AMT")%>', '<%=dly_pubcode%>', '<%=fee_scd.get("RENT_MNG_ID")%>', '<%=fee_scd.get("RENT_L_CD")%>', '<%=incom_dt%>', '<%=fee_scd.get("SEQID")%>')"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>
			  	   <% } %>
			       <%}%>  
			       
			       	<input type='hidden' name='rent_mng_id' value='<%=fee_scd.get("RENT_MNG_ID")%>'>
					<input type='hidden' name='rent_l_cd' value='<%=fee_scd.get("RENT_L_CD")%>'>
					<input type='hidden' name='rent_st' value='<%=fee_scd.get("RENT_ST")%>'>
					<input type='hidden' name='rent_seq' value='<%=fee_scd.get("RENT_SEQ")%>'>
					<input type='hidden' name='fee_tm' value='<%=fee_scd.get("TM")%>'>
					<input type='hidden' name='tm_st1' value='<%=fee_scd.get("TM1")%>'>
					<input type='hidden' name='tm_st2' value='<%=fee_scd.get("TM2")%>'>				
					<input type='hidden' name='car_mng_id' value='<%=fee_scd.get("CAR_MNG_ID")%>'>
					<input type='hidden' name='accid_id' value=''>			
					<input type='hidden' name='rtn_client_id' value='<%=fee_scd.get("CLIENT_ID")%>'>	
					<input type='hidden' name='cls_amt' value=''>
					<input type='hidden' name='rent_s_cd' value='<%=fee_scd.get("RENT_S_CD")%>'>	
				    <input type='hidden' name='tm1_nm' value='<%=fee_scd.get("TM1_NM")%>'>  
					<input type='hidden' name='gubun' value='<%=fee_scd.get("GUBUN")%>'>  
                    </td>
               		
                </tr>							
	<%				}
		}      %>
			   <tr>
                    <td colspan="7" class=title>�հ�</td>
                    <td class=title><input type='text' name='t_est_amt' size='14' readonly class='fixnum' value='<%=Util.parseDecimal(total_amt)%>'>��</td>
                    <td class=title><input type='text' name='t_pay_amt' size='14' readonly class='fixnum' value='<%=Util.parseDecimal(total_r_amt)%>'>��</td>
                  
               </tr>	

	        </table>
	
	    </td>  	
    </tr>       		
	<tr>
        <td><font color=red>*</font>&nbsp;����������� ��꼭����е� ���Ե� �� ������, �� �׸� ��꼭 ���࿩�� Ȯ���� �Ա�ǥ �����ϼ���. </td>
    </tr>          		    
 	<tr>
        <td class=h></td>
    </tr>  

	<tr id=tr_card style="display:<%if( base.getIp_method().equals("2") ){%>''<%}else{%>none<%}%>">    	
   	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ī�������&nbsp;</span></td>
 	 	  </tr>  
	      <tr>
	        <td class=line2></td>
	      </tr>
	      <tr>
	        <td class=line>
	          <table width=100% border=0 cellspacing=1 cellpadding=0>
	                <tr>	       
			            <td class=title width=13%>ī�������</td>
			            <td colspan="5">&nbsp;
						   <input type='text' name='card_tax' size='25' readonly class='num' value='<%=AddUtil.parseDecimal(base.getCard_tax())%>' >��</td>
		         	</tr>
		       
		        </table>
			  </td>
		    </tr>		  
		</table>
	   </td>  	
    </tr>	  	    
    <!--  ī��� �Ա��ΰ�� ��û�� �ݾ� ǥ�� -->
	<%	if( c_size > 0){      %>	    
    <tr>
        <td class=h></td>
    </tr>  
    
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                 	<td class="title" width='4%'>����</td>
                    <td class="title" width='29%'>ī���</td>
                    <td class="title" width='12%'>ī���ȣ</td>
                    <td class="title" width='21%'>����</td>					
                    <td class="title" width='10%'>û����</td>
                    <td class="title" width='12%'>û���ݾ�</td>					
                    <td class="title" width='12%'>������</td>
                 
                  
                </tr>
                
				<%	if(c_size > 0){
						for(int i = 0 ; i < c_size ; i++){
							Hashtable grt_scd = (Hashtable)vt_c.elementAt(i);
							total_c_amt 	= total_c_amt + Long.parseLong(String.valueOf(grt_scd.get("INCOM_AMT")));
							total_t_amt 	= total_t_amt + Long.parseLong(String.valueOf(grt_scd.get("CARD_TAX")));
						
				%>
			
                <tr>
                	<td align="center"><%=i+1%></td>	
                    <td align="center"><%=grt_scd.get("CARD_NM")%></td>		
					<td align="center"><%=grt_scd.get("CARD_NO")%></td>
                    <td align="center"><%=grt_scd.get("REMARK")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt_scd.get("ITEM_DT")))%></td>
                    <td align="center"><input type='text' name='c_est_amt' size='10' readonly  class='num' value='<%=Util.parseDecimal(String.valueOf(grt_scd.get("INCOM_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='c_pay_amt' size='10' readonly class='num' value='<%=Util.parseDecimal(String.valueOf(grt_scd.get("CARD_TAX")))%>'>��</td>
            
                   
                </tr>							
				<%		}
					}%>		
			
			    <tr>
                    <td colspan="5" class=title>�հ�</td>
                    <td class=title><input type='text' name='total_c_amt' size='14' readonly class='fixnum' value='<%=Util.parseDecimal(total_c_amt)%>'>��</td>
                    <td class=title><input type='text' name='total_t_amt' size='14' readonly class='fixnum' value='<%=Util.parseDecimal(total_t_amt)%>'>��</td>
               
                </tr>																																				
              																																			
            </table>
        </td>
    </tr>	
<% } %>    
    
    <tr>
        <td class=h></td>
    </tr>  
    
    <tr id=tr_acct8 style="display:<%if( !p_gubun.equals("4") ){%>''<%}else{%>none<%}%>"> 
       
       <td>
	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 	 	
			<tr>
			 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ÿ&nbsp;</span></td>
			</tr>	
			<tr>
		        <td class=line2></td>
		    </tr>
		 
		    <tr>
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		      
		          <tr> 
		            <td class=title width=13%>�ŷ�ó</td>
		            <td>&nbsp;
		            	<input name="n_ven_name" type="text"   class="text" value="<%=in_etc.getN_ven_name()%>" size="35" >	
		            	<input name="n_ven_code" type="hidden"	 value="<%=in_etc.getN_ven_code()%>" > 	
					</td>	
					         
					<td class=title width=13%>�ݾ�</td>
		            <td >&nbsp;<input type='text'   name='iip_acct_amt' readonly size='14'  class="num"  value='<%=AddUtil.parseDecimalLong(in_etc.getIp_acct_amt())%>' >��</td>
					   <input type='hidden' name='ip_acct_amt'  value='<%=in_etc.getIp_acct_amt()%>' >
					</td> 
		          </tr>	
		          <tr> 
		            <td class=title width=13%>�׸�</td>
		            <td>&nbsp;
		            	<select name="ip_acct"  >
		            		<option value='' <%if(in_etc.getIp_acct().equals("")) out.println("selected");%>>-����-</option>
			            	<option value='0' <%if(in_etc.getIp_acct().equals("0")) out.println("selected");%>>������</option>
			            	<option value='1' <%if(in_etc.getIp_acct().equals("1")) out.println("selected");%>>���°������</option>
			            	<option value='2' <%if(in_etc.getIp_acct().equals("2")) out.println("selected");%>>ä���߽ɼ�����</option>
			            	<option value='3' <%if(in_etc.getIp_acct().equals("3")) out.println("selected");%>>��ȯ��</option>
			            	<option value='26' <%if(in_etc.getIp_acct().equals("26")) out.println("selected");%>>�ǹ������</option>
			            	<option value='4' <%if(in_etc.getIp_acct().equals("4")) out.println("selected");%>>��å��</option>
			            	<option value='5' <%if(in_etc.getIp_acct().equals("5")) out.println("selected");%>>������</option>
			            	<option value='6' <%if(in_etc.getIp_acct().equals("6")) out.println("selected");%>>ī��ĳ����</option>
			            	<option value='17' <%if(in_etc.getIp_acct().equals("17")) out.println("selected");%>>������ĳ����</option>
			            	<option value='7' <%if(in_etc.getIp_acct().equals("7")) out.println("selected");%>>���ݰ�����</option>
			            	<option value='8' <%if(in_etc.getIp_acct().equals("8")) out.println("selected");%>>�ܻ�����</option>
			            	<option value='9' <%if(in_etc.getIp_acct().equals("9")) out.println("selected");%>>���޼�����</option>
			            	<option value='10' <%if(in_etc.getIp_acct().equals("10")) out.println("selected");%>>�����ޱ�</option>
			            	<option value='11' <%if(in_etc.getIp_acct().equals("11")) out.println("selected");%>>�����ޱ�</option>
			            	<option value='12' <%if(in_etc.getIp_acct().equals("12")) out.println("selected");%>>������</option>
			            	<option value='13' <%if(in_etc.getIp_acct().equals("13")) out.println("selected");%>>���·�̼���</option>
			            	<option value='14' <%if(in_etc.getIp_acct().equals("14")) out.println("selected");%>>���ޱ�</option>
			            	<option value='15' <%if(in_etc.getIp_acct().equals("15")) out.println("selected");%>>�̼���</option>    
			            	<option value='16' <%if(in_etc.getIp_acct().equals("16")) out.println("selected");%>>�ܱ����Ա�</option>  			          
				            <option value='18' <%if(in_etc.getIp_acct().equals("18")) out.println("selected");%>>���ڼ���</option>  
				            <option value='19' <%if(in_etc.getIp_acct().equals("19")) out.println("selected");%>>��������</option>  
				            <option value='20' <%if(in_etc.getIp_acct().equals("20")) out.println("selected");%>>��ݺ�</option>    
				            <option value='21' <%if(in_etc.getIp_acct().equals("21")) out.println("selected");%>>�������</option>  
				            <option value='22' <%if(in_etc.getIp_acct().equals("22")) out.println("selected");%>>�����޿�</option>   
				            <option value='23' <%if(in_etc.getIp_acct().equals("23")) out.println("selected");%>>���������</option>   
				            <option value='24' <%if(in_etc.getIp_acct().equals("24")) out.println("selected");%>>������������Ա�</option>   
				            <option value='25' <%if(in_etc.getIp_acct().equals("25")) out.println("selected");%>>����ȸ��������Ա�</option>  
		            	</select>
		         	</td>	
		      		<td class=title width=13%>��/����</td>
		            <td>&nbsp;
		            	<select name="acct_gubun" >
			            	<option value='C' <%if(in_etc.getAcct_gubun().equals("C")) out.println("selected");%>>�뺯</option>
			            	<option value='D' <%if(in_etc.getAcct_gubun().equals("D")) out.println("selected");%>>����</option>
		            	</select>
		            </td>	
		      			      						
		          </tr>		
		          <tr> 
		            <td class=title width=13%>Ư�̻���</td>
		            <td colspan=3 >&nbsp;
		                <input name="remark" type="text"    class="text" value="<%=in_etc.getRemark()%>" size="140" >	
		                
		               <%
		                  //��ü��� 
		               	//��� �Ա��� ���			
								int ep1=0;
								String cash_remark = "";
								cash_remark = in_etc.getRemark();
								ep1 = cash_remark.indexOf("��ü���ĳ�������");
								
								
								if ( ep1 != -1 ) {		
								  	dly_pubcode = in_db.getPayEbillDly("cash", "back", incom_dt);
								
								}	               
		               
		                 	if ( ep1 != -1 ) {		
								 	  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){     %>
								  	     <a href="javascript:view_agnt_email('cash', '<%=in_etc.getRemark()%>', '',  '', '<%=in_etc.getIp_acct_amt()%>', '<%=dly_pubcode%>', '<%=incom_seq%>', '<%=in_etc.getN_ven_code()%>', '<%=incom_dt%>', '')"><img src=/acar/images/center/button_in_igp.gif align=absmiddle border=0></a>
							<%	  	 } 
							 }  
			       		               
		                %>
		                
		                
		      		</td>		      						
		          </tr>			    
		        </table>
			  </td>
		    </tr>
		  
		</table>
	   </td>  	
    </tr>	 	     
    
    <!--  ����ȯ���� ��� -->
	<%	if( p_gubun.equals("4") ) {      %>
	    
    <tr>
        <td class=h></td>
    </tr>  
    
     <tr id=tr_acct9 style="display:''"> 
       
       <td>
	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 	 	
			<tr>
			 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����&nbsp;</span></td>
			</tr>	
			<tr>
		        <td class=line2></td>
		    </tr>
		 
		    <tr>
		       <td class='line'> 
		            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		                <tr>
		               		<td class="title" width='4%'>����</td>
		                 	<td class="title" width='4%'>����</td>
		                    <td class="title" width='10%'>����ȣ</td>
		                    <td class="title" width='11%'>������ȣ</td>
		                    <td class="title" width='16%'>����</td>					
		                    <td class="title" width='8%'>�����</td>
		                    <td class="title" width='8%'>��������</td>					
		                    <td class="title" width='8%'>�����߻���</td>
		                    <td class="title" width='8%'>û����</td>
		                    <td class="title" width='9%'>ȯ�޿����ݾ�</td>
		                    <td class="title" width='9%'>�Ա�ó���ݾ�</td>    
		                </tr>
		                
		                <%	if(ins_size > 0){
							for(int i = 0 ; i < ins_size ; i++){
									Hashtable ins = (Hashtable)inss.elementAt(i); 
									if ( String.valueOf(ins.get("INS_TM2")).equals("1") ) {
										ins_amt 	= Long.parseLong(String.valueOf(ins.get("PAY_AMT")))* (-1);	
									} else {
										ins_amt 	= Long.parseLong(String.valueOf(ins.get("PAY_AMT")));	
									}
															
									total_c_amt 	= total_c_amt + ins_amt;	
									total_t_amt 	= total_t_amt + ins_amt;	
																												
									
						%>
						
								
						<tr>
		                	<td align="center"><%=i+1%></td>
		                	<td align="center"><%=ins.get("INS_TM2_NM")%></td>	
		                    <td align="center"><%=ins.get("RENT_L_CD")%></td>		
							<td align="center"><%=ins.get("CAR_NO")%></td>
		                    <td align="center"><%=Util.subData(String.valueOf(ins.get("CAR_NM"))+" "+String.valueOf(ins.get("CAR_NAME")), 14)%></td>		
		                    <td align="center"><%=ins.get("INS_COM_NM")%></td>			
		                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%></td>
		                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
		                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("R_INS_EST_DT")))%></td>
		                    <td align="center"><input type='text' name='est_amt' size='10' readonly class='num' value='<%=Util.parseDecimal(ins_amt)%>'>��</td>
		                    <td align="center"><input type='text' name='pay_amt' size='10' readonly class='num' value='<%=Util.parseDecimal(ins_amt)%>'>��</td>
		                   
		                </tr>	
		               				
						<%		}
							}%>		
					
					    <tr>
		                    <td colspan="9" class=title>�հ�</td>
		                    <td class=title><input type='text' name='total_c_amt' size='14' readonly class='fixnum' value='<%=Util.parseDecimal(total_c_amt)%>'>��</td>
		                    <td class=title><input type='text' name='total_t_amt' size='14' readonly class='fixnum' value='<%=Util.parseDecimal(total_t_amt)%>'>��</td>
		                               
		                  
		                </tr>																																				
		              																																			
		            </table>
		        </td>
		    </tr>
		  
		</table>
	   </td>  	
    </tr>	 	     
    
<% } %>    

	<tr>
      <td>&nbsp;</td>
    </tr>

    <tr>
		<td align="right">
		<!-- card_cms �ΰ�츸 ��������  - ī������� �Ա�ó���Ǳ��� ��Ұ� ó�� -->
		 <%if (   base.getIp_method().equals("2") &&  !base.getJung_type().equals("6") ) { %> 	 			 
			 	 <a href="javascript:go_del();"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>			
		 <% } %>	 
		 	 &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;	 &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
		 	 <% if ( user_id.equals("000063") ) { %>  
		 	  <a href="javascript:save();">[��ǥ�����]</a>	
		 	 <% } %>
		 	 
			 <a href="javascript:go_list();"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>			
		
			 
			 	 
		</td>
	</tr>	
	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
