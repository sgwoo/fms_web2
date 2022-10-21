<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.user_mng.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"scd":request.getParameter("f_list");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String reg_yn 	= request.getParameter("reg_yn")==null?"":request.getParameter("reg_yn");
	String gubun	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cng_yn  	= "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	//�α���ID&������ID&����
	if(user_id.equals(""))  user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))  	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "02");
	
	//�뿩�⺻����
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	
	//��ü�� ����
	boolean flag = af_db.calDelay(m_id, l_cd);
	
	//�������
	Hashtable cont = t_db.getAllotByCase(m_id, l_cd);
	
	//����û������
	Vector rtn = af_db.getFeeRtnList(m_id, l_cd, rent_st);
	int rtn_size = rtn.size();
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(m_id, l_cd, taecha_no);
	
	//����������� ����Ʈ
	Vector ta_vt = a_db.getTaechaList(m_id, l_cd);
	int ta_vt_size = ta_vt.size();	
	
	//�������̰� ���
	Vector cng_cont_v = af_db.getScdFeeCngContList(m_id);
	int cng_cont_size = cng_cont_v.size();
	
	//���⺻����
	ContBaseBean c_base = a_db.getCont(m_id, l_cd);
	Hashtable cng_cont = af_db.getScdFeeCngContA(m_id, l_cd);
	Hashtable begin = a_db.getContBeginning(m_id, c_base.getReg_dt());
	
	
	//�������� ������ �뿩Ƚ�� �ִ밪
	int max_taecha_tm = a_db.getMax_fee_tm(m_id, l_cd, "");
	int scd_count = a_db.getScdCount(m_id, l_cd, "");
	
	String m_id2 = m_id;
	String l_cd2 = l_cd;
	if(mode.equals("m_id")){
		l_cd2 = "";
	}else{
		m_id2 = "";
	}
	
	String t_scd_reg_yn = "Y";
	if(fee.getPrv_dlv_yn().equals("Y") && max_taecha_tm == 0 && scd_count == 0 && (!taecha.getRent_mng_id().equals("") && taecha.getReq_st().equals("1") && taecha.getTae_st().equals("1"))){
		if(gubun.equals("") || gubun.equals("����")){
			t_scd_reg_yn = "N";
		}
	}
	
	long total_amt 	= 0;
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//rent_mng_id��, rent_l_cd�� ����Ʈ ��ȸ
	function Scd_fee(mode){
		var fm = document.form1;
		fm.mode.value = mode;
		fm.action="fee_scd_u.jsp";
		fm.target="d_content";		
		fm.submit();
	}
	
	//���°�, �������� ������� �̵�
	function Scd_fee_c(l_cd){
		var fm = document.form1;
		fm.l_cd.value = l_cd;
		fm.action="fee_scd_u.jsp";
		fm.target="d_content";		
		fm.submit();
	}	

	//�뿩�� ������ ����ȭ��
	function make_schedule(rent_st, idx)
	{
		var fm = document.form1;
		<%if(t_scd_reg_yn.equals("N")){%>
		if(confirm('�������� �������� �����ϴ�. Ȯ���Ͻʽÿ�. �����ٻ����� �Ͻðڽ��ϱ�?')){			
		<%}%>
			window.open("about:blank", "MKSCD", "left=50, top=50, width=850, height=625, scrollbars=yes, status=yes");				
			fm.rent_st.value = rent_st;
			fm.idx.value = idx;
			fm.action = "fee_scd_u_mkscd.jsp";
			fm.target = "MKSCD";
			fm.submit();				
		<%if(t_scd_reg_yn.equals("N")){%>
		}
		<%}%>
	}	

	//����ȭ��
	function cng_schedule(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD", "left=50, top=50, width=650, height=650, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "fee_scd_u_cngscd.jsp";
		fm.target = "CNGSCD";
		fm.submit();
	}		
	//����ȭ��
	function cng_schedule2(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD2", "left=50, top=50, width=650, height=400, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "fee_scd_u_cngscd2.jsp";
		fm.target = "CNGSCD2";
		fm.submit();
	}	
	//����ȭ��-�뿩�ὺ���ٺ���ó��
	function cng_schedule3(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD3", "left=50, top=50, width=650, height=500, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "fee_scd_u_cngscd3.jsp";
		fm.target = "CNGSCD3";
		fm.submit();
	}		
	//����ȭ��-�뿩�ὺ�����̰�
	function cng_schedule4(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD4", "left=50, top=50, width=950, height=500, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "fee_scd_u_cngscd4.jsp";
		fm.target = "CNGSCD4";
		fm.submit();
	}			
	//��ȸ���� ����
	function tm_update(idx, rent_seq, rent_st, fee_tm, tm_st1, tm_st2){
		var fm = document.form1;
		<%if(!mode.equals("view")){%>
		window.open("about:blank", "SCDUPD", "left=50, top=0, width=750, height=700, scrollbars=yes");				
		fm.idx.value = idx;
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.fee_tm.value = fee_tm;
		fm.tm_st1.value = tm_st1;
		fm.tm_st2.value = tm_st2;		
		fm.action = "fee_scd_u_tm.jsp";
		fm.target = "SCDUPD";
		fm.submit();
		<%}%>
	}	
	//���� ����
	function dt_update(fee_est_dt){
		var fm = document.form1;
		window.open("about:blank", "SCDDTUPD", "left=50, top=50, width=1000, height=800, scrollbars=yes");				
		fm.s_fee_est_dt.value = fee_est_dt;
		fm.action = "fee_scd_u_client_dt.jsp";
		fm.target = "SCDDTUPD";
		fm.submit();
	}		
	//ȸ������
	function add_schedule(rent_seq, rent_st, idx, cng_st){
		var fm = document.form1;
		window.open("about:blank", "ADDSCD", "left=50, top=0, width=650, height=500, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "fee_scd_u_addscd.jsp";
		fm.target = "ADDSCD";
		fm.submit();	
	}	
	//�繫ȸ�� �뿩������� �̵�	
	function move_fee_scd(){
		var fm = document.form1;	
		fm.target = 'd_content';	
		fm.action = '/fms2/con_fee/fee_c_mgr.jsp';
		fm.submit();								
	}
	
	//�뿩�� ������ �μ�ȭ��
	function print_view(rent_st)
	{
		var fm = document.form1;
		window.open("fee_scd_u_sc_print.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st="+rent_st, "SCD_PRINT_VIEW", "left=50, top=50, width=700, height=640, scrollbars=yes");
	}	
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='/fms2/con_fee/fee_scd_i_a.jsp' target='' method="post">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='reg_yn' value='<%=reg_yn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='idx' value=''>
<input type='hidden' name='cng_st' value=''>
<input type='hidden' name='tm_st1' value=''>
<input type='hidden' name='tm_st2' value=''>
<input type='hidden' name='fee_tm' value=''>
<input type='hidden' name='rent_seq' value=''>
<input type='hidden' name='s_fee_est_dt' value=''>
<input type='hidden' name='client_id' value='<%=cont.get("CLIENT_ID")%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>


<!--�����뿩------------------------------------------------------------------------------------------------------------------------------------------------>  

<%	if(gubun.equals("����")){%>  	
	<tr>
	    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� �����뿩
	        <%if(c_base.getRent_st().equals("3") && String.valueOf(cont.get("CAR_NO")).equals(taecha.getCar_no())){%><font color=red>(�����Ī����)</font><%}%>
	        </span>
	    </td>	
	</tr>
	<tr>
	    <td class=line2 colspan=2></td>
	</tr>	
	<%
		for(int i = 0 ; i < ta_vt_size ; i++){
			Hashtable ht = (Hashtable)ta_vt.elementAt(i);
       		taecha = a_db.getTaecha(m_id, l_cd, ht.get("NO")+"");
    %>  		
	<tr>
	    <td colspan="2" align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='10%' class='title'>������ȣ</td>
                    <td width='24%'>&nbsp;<input type="radio" name="taecha_no" value="<%=ht.get("NO")%>" <%if((i+1)==ta_vt_size){%>checked<%}%>><%=taecha.getCar_no()%></td>
                    <td width='10%' class='title'>����</td>
                    <td>&nbsp;<%=c_db.getNameById(taecha.getCar_id(), "FULL_CAR_NM")%></td>
                </tr>
                <tr>
                    <td class='title'>�뿩�Ⱓ</td>
                    <td>
        			&nbsp;<input type='text' name='rent_start_dt' value='<%=taecha.getCar_rent_st()%>' size='11' class='whitetext'>
        				      ~
        				<%if(!taecha.getCar_rent_et().equals("")){%>	  
        			      <input type='text' name='rent_end_dt' value='<%=taecha.getCar_rent_et()%>' size='11' class='whitetext'>
        				<%}else{%>
        			      <input type='text' name='rent_end_dt' value='<%=fee.getRent_start_dt()%>' size='11' class='whitetext'>
        				<%}%>
        				<!--
        				      (
        			      <input type='text' name='rent_mon' value='<%=taecha.getCar_rent_tm()%>' size='2' class='whitenum'>
        				      ȸ��)
        				-->      
        			</td>
                    <td class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>��&nbsp;&nbsp;</td>					  
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%} %>
<%		if(rtn_size == 0){
			Hashtable ht = new Hashtable();
			ht.put("FIRM_NM", String.valueOf(cont.get("FIRM_NM")));
			ht.put("RTN_AMT", String.valueOf(taecha.getRent_fee()));
			rtn.add(ht);
			rtn_size = rtn.size();
		}
		for(int r = 0 ; r < rtn_size ; r++){
			Hashtable r_ht = (Hashtable)rtn.elementAt(r);
			if(rtn_size>1){%>	
	<tr>
	    <td colspan="2">&nbsp;</td>	
	</tr>	  			
	<tr>
	    <td colspan="2" align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='10%' class='title'>���޹޴���</td>
                    <td width="25%">&nbsp;<%=r_ht.get("FIRM_NM")%></td>
                    <td width="10%" class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(r_ht.get("RTN_AMT")))%>��&nbsp;</td>
                    <td width='10%' class='title'>����</td>
                    <td width="15%">&nbsp;<%if(String.valueOf(r_ht.get("RTN_TYPE")).equals("4")){%>�����ݱյ����<%}else{%>�뿩��<%}%></td>
                </tr>
            </table>
        </td>
    </tr>	
<%				//�Ͻ���������
				FeeScdStopBean fee_stop = af_db.getFeeScdStopRtn(m_id, l_cd, String.valueOf(r+1));
				if(!fee_stop.getSeq().equals("")){%>
	<tr>
	    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��꼭 ���� �Ͻ�����</span></td>	
	</tr>	
	<tr>
	    <td class=line2 colspan=2></td>
	</tr>	
	<tr>
	    <td colspan="2" align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='10%' class='title'>����</td>
                    <td width='24%'>&nbsp;<%if(fee_stop.getStop_st().equals("1")){%>��ü<%}else{%>����û<%}%></td>
                    <td width='10%' class='title'>�����Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee_stop.getStop_s_dt())%>~<%=AddUtil.ChangeDate2(fee_stop.getStop_e_dt())%></td>
                </tr>
                <tr>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=fee_stop.getStop_cau()%></td>
                    <td class='title'>��������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee_stop.getCancel_dt())%></td>					  
                </tr>
    		    <%if(!fee_stop.getStop_doc_dt().equals("")){%>
                <tr>
                    <td class='title'>��������</td>
                    <td colspan="3">&nbsp;�߽����� : <%=AddUtil.ChangeDate2(fee_stop.getStop_doc_dt())%>, ��ĵ : <a href="/data/stop_doc/<%=fee_stop.getStop_doc()%>.pdf" target="_blank"><%=fee_stop.getStop_doc()%>.pdf</a></td>
                </tr>
    		    <%}%>
            </table>
	    </td>
    </tr>
<%				}%>  				
<%			}%>	
<%			//�����۾�������-����
			Vector fee_scd1 = ScdMngDb.getFeeScdTaxScd("", "3", "0", "", "", m_id2, l_cd2, c_id, "", String.valueOf(r+1));
			int fee_scd_size1 = fee_scd1.size();
			if(fee_scd_size1>0){%>  

	<tr><td colspan="2" align="right"><a href="javascript:print_view('');" title='�⺻' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a></td></tr>

	<tr>
	    <td colspan="2" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>	  
                <tr>
                    <td width='3%' rowspan="2" class='title'>����</td>				
                    <td width='3%' rowspan="2" class='title'>ȸ��</td>
                    <td colspan="2" rowspan="2" class='title'>���Ⱓ</td>
                    <td width="13%" rowspan="2" class='title'>���뿩��</td>
                    <td width="5%" rowspan="2" class='title'>û��<br>/�Ա�</td>
                    <td width="4%" rowspan="2" class='title'>��ü</td>
                    <td colspan="3" class='title'>������</td>
                    <td colspan="2" class='title'>�ŷ�����</td>					
                    <td colspan="2" class='title'>��꼭</td>
                </tr>
                <tr>
                  <td width="8%" class='title'>���࿹����</td>
                  <td width="8%" class='title'>��������</td>
                  <td width="8%" class='title'>�Աݿ�����</td>
                  <td width="8%" class='title'>�߱�����</td>
                  <td width="8%" class='title'>��������</td>
                  <td width="8%" class='title'>��������</td>
                  <td width="8%" class='title'>�������</td>
                </tr>
        <%		for(int i = 0 ; i < fee_scd_size1 ; i++){
					Hashtable ht = (Hashtable)fee_scd1.elementAt(i);
					if(String.valueOf(ht.get("RC_YN")).equals("0")) cng_yn = "Y"; 
					total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("FEE_AMT")));%>
                <tr>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=i+1%></td>				
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><a href="javascript:tm_update('<%=i%>','<%=String.valueOf(r+1)%>', '<%=ht.get("RENT_ST")%>','<%=ht.get("FEE_TM")%>','<%=ht.get("TM_ST1")%>','<%=ht.get("TM_ST2")%>')"><%=ht.get("FEE_TM")%></a></td>
                    <td width="8%" align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="8%" align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td align="right"  <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��&nbsp;&nbsp;</td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=ht.get("BILL_YN")%>/
                    	<%if(String.valueOf(ht.get("RC_YN")).equals("0")){ 		out.println("N");
                     	  }else if(String.valueOf(ht.get("RC_YN")).equals("1")){   	
                     	  	//�ܾ׿���
                     	  	if(af_db.getFeeTmJanAmt(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), String.valueOf(ht.get("RENT_ST")), String.valueOf(ht.get("RENT_SEQ")), String.valueOf(ht.get("FEE_TM")))>0){
                     	  		out.println("�ܾ�");
                     	  	}else{
                     	  		out.println("Y");
                     	  	}							
                     	  }%>
                    </td>
                    <td align="right"  <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=ht.get("DLY_DAYS")%>��&nbsp;</td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%><%if(String.valueOf(ht.get("ITEM_DT")).equals("")&&nm_db.getWorkAuthUser("ȸ�����",user_id)){%><a href="javascript:dt_update('<%=ht.get("FEE_EST_DT")%>')">.</a><%}%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ITEM_DT")))%><%if(!String.valueOf(ht.get("ITEM_DT")).equals("")){%><br><font color='999999'>(<%=ht.get("ITEM_ID")%>)</font><%}%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_EST_DT")))%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%><%if(!String.valueOf(ht.get("TAX_DT")).equals("")){%><br><font color='999999'>(<%=ht.get("TAX_NO")%>)</font><%}%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%></td>
                </tr>
        <%		}%>
		        <tr>
				  <td class="title" colspan="4">�հ�</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��&nbsp;</td>
				  <td class="title" colspan="9"></td>				  
				</tr>		
            </table>
        </td>
	</tr>
	<tr>
	    <td colspan="2">&nbsp;</td>	
	</tr>	  	
	<tr>
	    <td colspan="2" align="right">
		<%		if(nm_db.getWorkAuthUser("ȸ�����",user_id)){%> 
		  <span class="b"><a href="javascript:add_schedule('<%=String.valueOf(r+1)%>', '', 1, 'scd_add');"><img src=/acar/images/center/button_hcyj.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '', 1, 'fee_amt');"><img src=/acar/images/center/button_ch_fee.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '', 1, 'req_dt');"><img src=/acar/images/center/button_ch_pub.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;   
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '', 1, 'tax_out_dt');"><img src=/acar/images/center/button_ch_tax.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '', 1, 'fee_est_dt');"><img src=/acar/images/center/button_ch_dep.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;
		  <span class="b"><a href="javascript:cng_schedule2('<%=String.valueOf(r+1)%>', '',1, 'use_dt');"><img src=/acar/images/center/button_ch_use.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;	
		  <%if(rtn_size==1){%>	
		  <span class="b"><a href="javascript:cng_schedule3('<%=String.valueOf(r+1)%>', '', 1, 'fee_amt');"><img src=/acar/images/center/button_dyrbh.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 		  
		  <%}%>
		<%		}%>		
		  <span class="b"><a href="javascript:move_fee_scd();"><img src=/acar/images/center/button_igcl.gif border=0 align=absmiddle></a></span>	  		  		    		  		
	    </td>
	</tr>		
<%			}else if(fee_scd_size1==0 && !taecha.getReq_st().equals("0")){%>  			
	<tr>
	    <td colspan="2" align="right">
		<%		if(nm_db.getWorkAuthUser("ȸ�����",user_id) && String.valueOf(begin.get("RENT_L_CD")).equals("null")){%>
		<%			if(String.valueOf(cont.get("CAR_ST")).equals("3") && AddUtil.parseInt(String.valueOf(cont.get("CON_MON"))) < 12){%>
<!--		    ���� 12�����̸��� �뿩�� �� �����ϴ�. -->
            <a href="javascript:make_schedule('', 1);"><img src=/acar/images/center/button_sch_cre.gif  align=absmiddle border="0"></a>      		
		<%			}else{%>
      		<a href="javascript:make_schedule('', 1);"><img src=/acar/images/center/button_sch_cre.gif  align=absmiddle border="0"></a>
		<%			}%>
		<%		}%>		
	    </td>
	</tr>	
<%			}%>	
<%		}%>	

<!--����(����)�뿩------------------------------------------------------------------------------------------------------------------------------------------------>

<%	}else{%>
<%		ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, rent_st);

		//fee_etc
		ContCarBean ext_fee_etc = a_db.getContFeeEtc(m_id, l_cd, rent_st);
		

		//fee_rm
		ContFeeRmBean fee_rm = a_db.getContFeeRm(m_id, l_cd, rent_st);%>	
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(rent_st.equals("1")){%>����<%}else{%><%=AddUtil.parseInt(rent_st)-1%>�� ����<%}%>�뿩</span></td>
	    <td align='right'>
	    <span class="c"><a href="javascript:location.reload()"><img src=/acar/images/center/button_reload.gif border=0 align=absmiddle></a></span>		
		</td>	
	</tr>
	<tr>
	    <td colspan="2" class=line2></td>	
	</tr>	
	<tr>
	    <td colspan="2" align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='10%' class='title'>�뿩�Ⱓ</td>
                    <td width="24%">&nbsp;
                      <input type='text' name='rent_start_dt' value='<%=ext_fee.getRent_start_dt()%>' size='11' class='whitetext'>
                      ~
                      <input type='text' name='rent_end_dt' value='<%=ext_fee.getRent_end_dt()%>' size='11' class='whitetext'>
        				(
        			  <input type='text' name='rent_mon' value='<%=ext_fee.getCon_mon()%>' size='2' class='whitenum'>
        				����
        				<%if(c_base.getCar_st().equals("4")){%>
        				<input type='text' name='rent_day' value='<%=ext_fee_etc.getCon_day()%>' size='2' class='whitenum'>
        				��
        				<%}%>
        				)</td>
                    <td width=10%" class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>��&nbsp;</td>
                    <td width=10%" class='title'>��������</td>
                    <td>&nbsp;<%if(ext_fee.getFee_est_day().equals("98")){%>�뿩������<%}else{%>�ſ�<%if(ext_fee.getFee_est_day().equals("99")){%>����<%}else{%><%=ext_fee.getFee_est_day()%>��<%}%><%}%></td>
                </tr>
                <tr>
                    <td class='title'>������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>��&nbsp;</td>
                    <td class='title'>������</td>
                    <td width=16%>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>��&nbsp;</td>
                    <td width="10%" class='title'>���ô뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>��&nbsp;
                        <%if(ext_fee.getFee_s_amt() >0){%>
                        <%	if(ext_fee.getPere_r_mth() == 0){%>    
                        (<%=(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())/(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>ȸ)
                        <%	}else{%>
                        (<%=ext_fee.getPere_r_mth()%>ȸ)
                        <%	}%>
                        <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���뿩�ᳳ�Թ��</td>
                    <td>&nbsp;<%if(ext_fee.getFee_chk().equals("0")){%>�ſ�����<%}else if(ext_fee.getFee_chk().equals("1")){%>�Ͻÿϳ�<%}else{%>-<%}%></td>
                    <td class=title>�����ݰ�꼭���౸��</td>
                    <td colspan='3'>&nbsp;<%if(ext_fee.getPp_chk().equals("1")){%>�����Ͻù���<%}else if(ext_fee.getPp_chk().equals("0")){%>�ſ��յ����<%}else{%>-<%}%></td>
                </tr>                       
                <%if(c_base.getCar_st().equals("4")){%>
                <tr>
                    <td class='title'>������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt())%>��</td>
                    <td class='title'>������</td>
                    <td width=16%>&nbsp;<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>��</td>
                    <td width="10%" class='title'>���ʳ��Թ��</td>
                    <td>&nbsp;���ʰ����ݾ� <%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>, 
                                <%if(fee_rm.getF_paid_way().equals("1")){%>ùȸ�� �뿩��<%}%>
		        	<%if(fee_rm.getF_paid_way().equals("2")){%>�뿩�� �Ѿ�<%}%>		        	
		        	<%if(fee_rm.getCons1_s_amt()>0){%>+ ��/������<%}%>
                    </td>
                </tr>                
                <%}%>
				<tr>
				    <td class='title'>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
					<td colspan='5'><%=ext_fee.getFee_cdt()%></td>
				</tr>
				<tr>
				    <td class='title'>��༭ Ư����� ���� ����</td>
					<td colspan='5'><%=ext_fee_etc.getCon_etc()%></td>
				</tr>
            </table>
        </td>
    </tr>	
    <!--���ǿ���-->
    <%		//���ǿ���
		Vector im_vt = af_db.getFeeImList(m_id, l_cd, rent_st);
		int im_vt_size = im_vt.size();
    %>
	<%if(im_vt_size>0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǿ���</span> </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">����</td>
                    <td class=title width="20%">ȸ��</td>			
                    <td class=title width="37%">�뿩�Ⱓ</td>
                    <td class=title width="15%">�����</td>
                    <td class=title width="15%">�����</td>                    
                  </tr>
        		  <%	for(int i = 0 ; i < im_vt_size ; i++){
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=im_ht.get("ADD_TM")%>ȸ��</td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td>
                    <td align='center'><%=im_ht.get("USER_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("REG_DT")))%></td>
                  </tr>
        		  <%	} %>
            </table>
        </td>
    </tr>				
    <tr>
        <td class=h></td>
    </tr>			
	<%}%>    
    
<%		
		if(rtn_size == 0){
			Hashtable ht = new Hashtable();
			ht.put("FIRM_NM", String.valueOf(cont.get("FIRM_NM")));
			ht.put("RTN_AMT", String.valueOf(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt()));
			rtn.add(ht);
			rtn_size = rtn.size();
		}
		for(int r = 0 ; r < rtn_size ; r++){
			Hashtable r_ht = (Hashtable)rtn.elementAt(r);
			if(rtn_size>1){%>					
	<tr>
	    <td colspan="2">&nbsp;</td>	
	</tr>	  			
	<tr>
	    <td colspan="2" align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
    	    	<tr><td class=line2></td></tr>
                <tr>
                    <td width='10%' class='title'>���޹޴���</td>
                    <td width="24%">&nbsp;<%=r_ht.get("FIRM_NM")%></td>
                    <td width="10%" class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(r_ht.get("RTN_AMT")))%>��&nbsp;</td>
                    <td width='10%' class='title'>����</td>
                    <td width="15%">&nbsp;<%if(String.valueOf(r_ht.get("RTN_TYPE")).equals("4")){%>�����ݱյ����<%}else{%>�뿩��<%}%></td>
                </tr>
            </table>
        </td>
    </tr>	
<%				//�Ͻ���������
				FeeScdStopBean fee_stop = af_db.getFeeScdStopRtn(m_id, l_cd, String.valueOf(r+1));
				if(!fee_stop.getSeq().equals("")){%>
	<tr>
	    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��꼭 ���� �Ͻ�����</span></td>	
	</tr>	
	<tr>
	    <td class=line2 colspan=2></td>
	</tr>	
	<tr>
	    <td colspan="2" align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='10%' class='title'>����</td>
                    <td width='24%'>&nbsp;<%if(fee_stop.getStop_st().equals("1")){%>��ü<%}else{%>����û<%}%></td>
                    <td width='10%' class='title'>�����Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee_stop.getStop_s_dt())%>~<%=AddUtil.ChangeDate2(fee_stop.getStop_e_dt())%></td>
                </tr>
                <tr>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=fee_stop.getStop_cau()%></td>
                    <td class='title'>��������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee_stop.getCancel_dt())%></td>					  
                </tr>
    		    <%if(!fee_stop.getStop_doc_dt().equals("")){%>
                <tr>
                    <td class='title'>��������</td>
                    <td colspan="3">&nbsp;�߽����� : <%=AddUtil.ChangeDate2(fee_stop.getStop_doc_dt())%>, ��ĵ : <a href="/data/stop_doc/<%=fee_stop.getStop_doc()%>.pdf" target="_blank"><%=fee_stop.getStop_doc()%>.pdf</a></td>
                </tr>
    		    <%}%>
            </table>
	    </td>
    </tr>
<%				}%>  		
<%			}%>
<%			//�����۾�������-����
			Vector fee_scd = ScdMngDb.getFeeScdTaxScd("", "3", rent_st, "", "", m_id2, l_cd2, c_id, "", String.valueOf(r+1));
			int fee_scd_size = fee_scd.size();
			if(fee_scd_size>0){%>  	

        <tr><td colspan="2" align="right"><a href="javascript:print_view('<%=rent_st%>');" title='�⺻' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a></td></tr>

	<tr>
	    <td colspan="2" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>	 
                <tr>
                    <td width='3%' rowspan="2" class='title'>����</td>
                    <td width='3%' rowspan="2" class='title'>ȸ��</td>					
                    <td colspan="2" rowspan="2" class='title'>���Ⱓ</td>
                    <td width="13%" rowspan="2" class='title'>���뿩��</td>
                    <td width="5%" rowspan="2" class='title'>û��<br>/�Ա�</td>
                    <td width="4%" rowspan="2" class='title'>��ü</td>
                    <td colspan="3" class='title'>������</td>
                    <td colspan="2" class='title'>�ŷ�����</td>					
                    <td colspan="2" class='title'>��꼭</td>
                </tr>
                <tr>
                  <td width="8%" class='title'>���࿹����</td>
                  <td width="8%" class='title'>��������</td>
                  <td width="8%" class='title'>�Աݿ�����</td>
                  <td width="8%" class='title'>�߱�����</td>
                  <td width="8%" class='title'>��������</td>
                  <td width="8%" class='title'>��������</td>
                  <td width="8%" class='title'>�������</td>
                </tr>
        <%				total_amt = 0;
						for(int j = 0 ; j < fee_scd_size ; j++){
        					Hashtable ht = (Hashtable)fee_scd.elementAt(j);
        					l_cd2 = String.valueOf(ht.get("RENT_L_CD"));
        					if(String.valueOf(ht.get("RC_YN")).equals("0")) cng_yn = "Y"; 
							total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("FEE_AMT")));%>
                <tr>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=j+1%></td>				
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>>
        		    <%if(!l_cd.equals(l_cd2)){%>		  		  
        		    <a href="javascript:Scd_fee_c('<%=ht.get("RENT_L_CD")%>')"><%=ht.get("FEE_TM")%></a>
        		    <%}else{%>
        		    <a href="javascript:tm_update('<%=j%>','<%=String.valueOf(r+1)%>', '<%=ht.get("RENT_ST")%>','<%=ht.get("FEE_TM")%>','<%=ht.get("TM_ST1")%>','<%=ht.get("TM_ST2")%>')"><%=ht.get("FEE_TM")%></a>
        		    <%}%>		  
        		    </td>
                    <td width="8%" align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="8%" align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td align="right"  <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��&nbsp;&nbsp;</td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=ht.get("BILL_YN")%>/
                    	<%if(String.valueOf(ht.get("RC_YN")).equals("0")){ 		out.println("N");
                     	  }else if(String.valueOf(ht.get("RC_YN")).equals("1")){   	
                     	  	//�ܾ׿���
                     	  	if(af_db.getFeeTmJanAmt(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), String.valueOf(ht.get("RENT_ST")), String.valueOf(ht.get("RENT_SEQ")), String.valueOf(ht.get("FEE_TM")))>0){
                     	  		out.println("�ܾ�");
                     	  	}else{
                     	  		out.println("Y");
                     	  	}							
                     	  }%>                     	  
                    </td>
                    <td align="right"  <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=ht.get("DLY_DAYS")%>��&nbsp;</td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%><%if(String.valueOf(ht.get("ITEM_DT")).equals("")&&nm_db.getWorkAuthUser("ȸ�����",user_id)){%><a href="javascript:dt_update('<%=ht.get("FEE_EST_DT")%>')">.</a><%}%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ITEM_DT")))%><%if(!String.valueOf(ht.get("ITEM_DT")).equals("")){%><br><font color='999999'>(<%=ht.get("ITEM_ID")%>)</font><%}%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_EST_DT")))%></td>										
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>>
        		    <%if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
          		    <%}else{%>					
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
					<%}%>
					<%if(!String.valueOf(ht.get("TAX_DT")).equals("")){%><br><font color='999999'>(<%=ht.get("TAX_NO")%>)</font><%}%>
        		    </td>
                    <td align="center" <%if(!String.valueOf(ht.get("RENT_L_CD")).equals(l_cd)){%>class="is"<%}%> <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>>
        		    <%if(String.valueOf(ht.get("PRINT_DT")).equals("")){%>
        		    <%	if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    	<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
          		    <%	}else{%>
						<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
					<%	}%>
        		    <%}else{%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%>
        		    <%}%>
        		    </td>
                </tr>
        <%					}%>
		        <tr>
				  <td class="title" colspan="4">�հ�</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��&nbsp;</td>
				  <td class="title" colspan="9"></td>				  
				</tr>		
            </table>
	    </td>
    </tr>
	<tr>
	    <td colspan="2">* ���ǿ��� �������� ȸ�������� ������� ����մϴ�.</td>	
	</tr>	  	
	<%if(!mode.equals("view")){%> 
	<tr>
	    <td colspan="2" align="right">
		<%if(nm_db.getWorkAuthUser("ȸ�����",user_id)){%> 
		  <%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id) || nm_db.getWorkAuthUser("�λ꽺���ٻ�����",user_id) || nm_db.getWorkAuthUser("����/�°�����",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id)){%>
		  <span class="b"><a href="javascript:add_schedule('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'scd_add');"><img src=/acar/images/center/button_hcyj.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;
		  <%	}%>
		  
		  
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'fee_amt');"><img src=/acar/images/center/button_ch_fee.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'req_dt');"><img src=/acar/images/center/button_ch_pub.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;    
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'tax_out_dt');"><img src=/acar/images/center/button_ch_tax.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'fee_est_dt');"><img src=/acar/images/center/button_ch_dep.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 
		  <span class="b"><a href="javascript:cng_schedule2('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'use_dt');"><img src=/acar/images/center/button_ch_use.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 		  
		  <%if(rtn_size==1){%>	
		  <span class="b"><a href="javascript:cng_schedule3('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'fee_amt');"><img src=/acar/images/center/button_dyrbh.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 		  
		  <%}%>
		<%}%>		  
		
		  <!--����Ʈ�϶�-->
		  <% 	if(String.valueOf(cont.get("CAR_ST")).equals("4") && nm_db.getWorkAuthUser("����Ʈ����",user_id)){%>
		  <span class="b"><a href="javascript:add_schedule('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'scd_add');"><img src=/acar/images/center/button_hcyj.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;
		  <%	}%>

		
		<%if(nm_db.getWorkAuthUser("������������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) ||  nm_db.getWorkAuthUser("����/�°�����",user_id)   ){%>		
		  <%if(cng_cont_size > 0 && !String.valueOf(cng_cont.get("CLS_DT")).equals("")){%>
		    <%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5") || String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>
		      <span class="b"><a href="javascript:cng_schedule4('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'scd_fee');"><img src=/acar/images/center/button_sch_ig.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 		  		  
		    <%}%>
		  <%}%>
		<%}%>		  
		  <span class="b"><a href="javascript:move_fee_scd();"><img src=/acar/images/center/button_igcl.gif border=0 align=absmiddle></a></span>	  		  
	    </td>
	</tr>		
	<%}%>  
<%			}%>  
<%			if(fee_scd_size==0){%>  			
	<tr>
	    <td colspan="2" align="right">
	  <% 	if((ext_fee.getFee_s_amt()>0 && !ext_fee.getFee_chk().equals("1")) || ext_fee.getPp_chk().equals("0")){%>
		<%		if(nm_db.getWorkAuthUser("ȸ�����",user_id) || nm_db.getWorkAuthUser("����Ʈ����",user_id)){%> 
		<%			if(!l_cd.equals("S112HGDL00073") && String.valueOf(cont.get("CAR_ST")).equals("3") && AddUtil.parseInt(ext_fee.getCon_mon()) < 12 && ext_fee.getRent_st().equals("1")){%>
		    ���� 12�����̸��� �뿩�� �� �����ϴ�.
		    <!--���°�� �űԽ������� �����Ҽ� �����ϴ�.-->
		<%			}else{%>		
      		
      		<a href="javascript:make_schedule('<%=ext_fee.getRent_st()%>', 2);"><img src=/acar/images/center/button_sch_cre.gif  align=absmiddle border="0"></a>
		<%			}%>
		<%		}%>
		<%	}%>
		<%if(nm_db.getWorkAuthUser("������������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) ||  nm_db.getWorkAuthUser("����/�°�����",user_id)   ){%>		
		  <%if(!String.valueOf(cng_cont.get("CLS_DT")).equals("")){%>
		  <%}%>
		<%}%>
		
		<%		if(nm_db.getWorkAuthUser("������",user_id)){%>
		<a href="javascript:make_schedule('<%=ext_fee.getRent_st()%>', 2);">.</a>
		<%}%>	
		
		<!-- �Ͻÿϳ� ���°�� �������̰��� �ִ�. -->
		<%if(nm_db.getWorkAuthUser("������������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) ||  nm_db.getWorkAuthUser("����/�°�����",user_id)   ){%>		
		  <%if(ext_fee.getFee_chk().equals("1") && cng_cont_size > 0 && !String.valueOf(cng_cont.get("CLS_DT")).equals("")){%>
		    <%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5") || String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>
		      <span class="b"><a href="javascript:cng_schedule4('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'scd_fee');"><img src=/acar/images/center/button_sch_ig.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 		  		  
		    <%}%>
		  <%}else if(ext_fee.getFee_s_amt()==0 && ext_fee.getPp_s_amt()>0){//���°�, ���뿩��0, ������ ����%>
		    <%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5") || String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>
		      <span class="b"><a href="javascript:cng_schedule4('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'scd_fee');"><img src=/acar/images/center/button_sch_ig.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 		  		  
		    <%}%>
		  <%} %>
		<%}%>	

	    </td>
	</tr>	
<%			}%>
<%		}%>
<%	}%>	
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>


