<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*, acar.doc_settle.*, acar.fee.*, acar.cls.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.end_cont.End_ContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//��������
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	Hashtable end_cont = ec_db.selectEnd_Cont(rent_mng_id, rent_l_cd);
	
	//����û������
	Vector rtn = af_db.getFeeRtnList(rent_mng_id, rent_l_cd, ext_fee.getRent_st());
	int rtn_size = rtn.size();
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//���ǿ���
	FeeImBean im = af_db.getFeeIm(doc.getDoc_id());
	
	//���������
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	long total_amt 	= 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	
	//����Ʈ
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'lc_im_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	
		
	//�� ����
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���õ� ���� �����ϴ�."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site()
	{
		var fm = document.form1;
		if(fm.site_id.value == ""){ alert("���õ� ������ �����ϴ�."); return;}
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//��꼭�Ͻ���������
	function FeeScdStop(){
		var fm = document.form1;
		window.open("about:blank", "ScdStopList", "left=50, top=50, width=750, height=550, scrollbars=yes");				
		fm.action = "/fms2/con_fee/fee_scd_u_stoplist.jsp";
		fm.target = "ScdStopList";
		fm.submit();
	}
	
	//�ŷ�ó �ֱ� ���࿹���� ����
	function clientFeeReqDt(client_id){
		window.open("/fms2/con_fee/client_feereqdt.jsp?client_id="+client_id, "clientFeeReqDt", "left=100, top=100, width=900, height=700, scrollbars=yes");
	}	
		
	//�����ٺ����̷�
	function FeeScdCngList(){
		var fm = document.form1;
		window.open("about:blank", "ScdCngList", "left=50, top=50, width=800, height=500, scrollbars=yes");				
		fm.action = "/fms2/con_fee/fee_scd_u_cnglist.jsp";
		fm.target = "ScdCngList";
		fm.submit();	
	}	
		
	//����ȭ��
	function cng_schedule(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD", "left=50, top=50, width=650, height=500, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "/fms2/con_fee/fee_scd_u_cngscd.jsp";
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
		fm.action = "/fms2/con_fee/fee_scd_u_cngscd2.jsp";
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
		fm.action = "/fms2/con_fee/fee_scd_u_cngscd3.jsp";
		fm.target = "CNGSCD3";
		fm.submit();
	}		
	//����ȭ��-�뿩�ὺ�����̰�
	function cng_schedule4(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD4", "left=50, top=50, width=950, height=300, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "/fms2/con_fee/fee_scd_u_cngscd4.jsp";
		fm.target = "CNGSCD4";
		fm.submit();
	}			
	//��ȸ���� ����
	function tm_update(idx, rent_seq, rent_st, fee_tm, tm_st1, tm_st2){
		var fm = document.form1;
		window.open("about:blank", "SCDUPD", "left=50, top=50, width=750, height=600, scrollbars=yes");				
		fm.idx.value = idx;
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.fee_tm.value = fee_tm;
		fm.tm_st1.value = tm_st1;
		fm.tm_st2.value = tm_st2;		
		fm.action = "/fms2/con_fee/fee_scd_u_tm.jsp";
		fm.target = "SCDUPD";
		fm.submit();
	}	
	//���� ����
	function dt_update(fee_est_dt){
		var fm = document.form1;
		window.open("about:blank", "SCDDTUPD", "left=50, top=50, width=1000, height=800, scrollbars=yes");				
		fm.s_fee_est_dt.value = fee_est_dt;
		fm.action = "/fms2/con_fee/fee_scd_u_client_dt.jsp";
		fm.target = "SCDDTUPD";
		fm.submit();
	}		
			
	//�뿩�Ⱓ ����
	function ScdfeeSet()
	{
		var fm = document.form1;
		
		if(toInt(fm.add_tm.value) > 5)	{ alert('���ǿ����� 5������ �ʰ��Ͽ� �Է��� �� �����ϴ�.'); 	fm.add_tm.focus(); 		return; }
		
		if(fm.rent_start_dt.value != '' && fm.add_tm.value != ''){
			fm.action = "/fms2/con_fee/fee_scd_set_nodisplay.jsp";
			fm.target = "i_no";
			fm.submit();
		}
	}			
	
	//���տ��ο� ���� ���÷���
	function display_rtn(){
		var fm = document.form1;		
		if(fm.rtn_st.checked == true){ 					
			tr_rtn.style.display = '';		
		}else{											
			tr_rtn.style.display = 'none';							
		}	
	}
	
			
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_im_doc_sanction.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}									
	}

	function FeeDoc(){
		var fm = document.form1;
		window.open("lc_im_doc_print.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&rent_st="+fm.rent_st.value+"&im_seq=<%=im.getIm_seq()%>", "FEEIM_DOC", "left=50, top=50, width=750, height=700, scrollbars=yes");				
	}
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>    
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"	 	value="<%=ext_fee.getRent_st()%>">
  <input type='hidden' name="from_page" 	value="/fms2/lc_rent/lc_im_doc_u.jsp">             
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name='client_id' 	value='<%=client.getClient_id()%>'>  
<input type='hidden' name='idx' value=''>
<input type='hidden' name='cng_st' value=''>
<input type='hidden' name='tm_st1' value=''>
<input type='hidden' name='tm_st2' value=''>
<input type='hidden' name='fee_tm' value=''>
<input type='hidden' name='rent_seq' value=''>
<input type='hidden' name='s_fee_est_dt' value=''>
<input type='hidden' name="doc_bit" value="">  
<input type='hidden' name="idx" value="">  
<input type='hidden' name="mode" value="">  

        
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���ڹ��� > <span class=style5>���ǿ��幮��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align="right"><%if(!mode.equals("view")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td></td>
	<tr> 	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>�뵵/����</td>
                    <td width=10%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%>
					&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></td>
                    <td class=title width=10%>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>��ȣ</td>
                    <td >&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%> <%=site.getR_site()%></a></td>
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title>����</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        			<font color="#999999">(�����ڵ�:<%=cm_bean.getJg_code()%>)</font>
        			</td>
                </tr>
				<%if(!cms.getCms_bank().equals("")){%>
                <tr>
                     <td class='title'>CMS</td>
                     <td colspan='5'>&nbsp;
						<b><%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%></b>
        			 	<%=cms.getCms_bank()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%> (�ſ� <%=cms.getCms_day()%>��)
					 </td>                     
                </tr>							
        		<%}%>		
				<%if(!client.getEtc().equals("")){%>	 				
                <tr>
                     <td class='title'>�� Ư�̻���</td>
                     <td colspan='5'>&nbsp;<%=Util.htmlBR(client.getEtc())%></td>                     
                </tr>		
        		<%}%>						
				<%if(!String.valueOf(end_cont.get("RE_BUS_NM")).equals("") && !String.valueOf(end_cont.get("RE_BUS_NM")).equals("null")){%>				
                <tr>
                     <td class='title'>����������Ȳ</td>
                     <td colspan='5'>&nbsp;<%=end_cont.get("REG_DT")%> : [<%=end_cont.get("RE_BUS_NM")%>] <%=end_cont.get("CONTENT")%></td>                     
                </tr>	
				<%}%>						
                <tr>
                     <td class='title'>��꼭���౸��</td>
                     <td>&nbsp;
					  <%if(client.getPrint_st().equals("1")) 		out.println("���Ǻ�");
                      	else if(client.getPrint_st().equals("2"))   out.println("<b><font color='#FF9933'>�ŷ�ó����</font></b>");
                      	else if(client.getPrint_st().equals("3")) 	out.println("<b><font color='#FF9933'>��������</font></b>");
                     	else if(client.getPrint_st().equals("4"))	out.println("<b><font color='#FF9933'>��������</font></b>");%>
						</td>                     
                     <td class='title'>��������</td>
					 <td colspan='3'>&nbsp;<font color=red><%=AddUtil.ChangeDate2(cls.getCls_dt())%></font></td>	
                </tr>					
            </table>
	    </td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="3">��<br>��<br>��<br>��<br></td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">�������</td>
                    <td style="font-size : 8pt;" width="6%" class=title rowspan="2">�̿�Ⱓ</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�뿩������</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�뿩������</td>
                    <td style="font-size : 8pt;" width="7%" class=title rowspan="2">�����</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">���뿩��</td>
                    <td style="font-size : 8pt;" class=title colspan="2">������</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">������</td>
                    <td style="font-size : 8pt;" class=title colspan="2">���ô뿩��</td>
                    <td style="font-size : 8pt;" class=title colspan="2">���Կɼ�</td>
                </tr>
                <tr>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>%</td>			
                </tr>
    		  <%//for(int i=0; i<fee_size; i++){
//    				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
					ContFeeBean fees = ext_fee;
//    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <!--<td style="font-size : 8pt;" align="center"><%//=i+1%></td>-->
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>����</td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getRent_st().equals("1")){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%if(fees.getIfee_s_amt()>0){%><%if(fees.getPere_r_mth()>0){%><%=fees.getPere_r_mth()%><%}else{%><%=fees.getIfee_s_amt()/fees.getFee_s_amt()%><%}%>ȸ&nbsp;<%}%><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%//}}%>
            </table>
	    </td>
	</tr>	
	<tr>
	    <td align="right">&nbsp;
                <a href="javascript:FeeScdStop()"><img src=/acar/images/center/button_ncha.gif  align=absmiddle border="0"></a>&nbsp;&nbsp;		
				<a href="javascript:clientFeeReqDt('<%=base.getClient_id()%>')"><img src=/acar/images/center/button_conf_bh.gif align=absmiddle border="0"></a>&nbsp;&nbsp;
			    <a href="javascript:FeeScdCngList()"><img src=/acar/images/center/button_scd_bgir.gif  align=absmiddle border="0"></a>&nbsp;&nbsp;		
		</td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǿ���</span></td>	
	</tr>	  	
    <tr>
        <td class=line2></td>
    </tr>		
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title'>����ȸ��</td>
                    <td>
                      &nbsp;<input type='text' size='3' name='add_tm' value='<%=im.getAdd_tm()%>' maxlength='2' class='whitetext'>ȸ
					  </td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>����뿩�Ⱓ</td>
                    <td>&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(im.getRent_start_dt())%>' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        			  ~
        			  <input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(im.getRent_end_dt())%>' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        			</td>
                </tr>							
                <tr>
                    <td width="3%" rowspan="4" class='title'>1ȸ��</td>
                    <td class='title'>���Ⱓ</td>
                    <td>
                      &nbsp;<input type='text' name='f_use_start_dt' value='<%=AddUtil.ChangeDate2(im.getF_use_start_dt())%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                      ~
                      <input type='text' name='f_use_end_dt' value='<%=AddUtil.ChangeDate2(im.getF_use_end_dt())%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value); '>
        		    </td>
                </tr>
                <tr>
                    <td width="10%" class='title'>���࿹����</td>
                    <td>
                        &nbsp;<input type='text' name='f_req_dt' value='<%=AddUtil.ChangeDate2(im.getF_req_dt())%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 
					</td>
                </tr>
                <tr>
                    <td class='title'>��������</td>
                    <td>
                        &nbsp;<input type='text' name='f_tax_dt' value='<%=AddUtil.ChangeDate2(im.getF_tax_dt())%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 
                    </td>
                </tr>						
                <tr>
                    <td class='title'>�Աݿ�����</td>
                    <td>
                        &nbsp;<input type='text' name='f_est_dt' value='<%=AddUtil.ChangeDate2(im.getF_est_dt())%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>		
	<% 	String im_rent_end_dt 	=  c_db.addMonth(im.getRent_start_dt(), AddUtil.parseInt(im.getAdd_tm()));
		im_rent_end_dt = c_db.addDay(im_rent_end_dt, -1);%>
    <tr>
        <td>
			<%if(!im_rent_end_dt.equals(im.getRent_end_dt())){%>
			<font color=red>�� ����ȸ���� ����뿩�Ⱓ �������� ���� �ʽ��ϴ�. ����ȸ���� �´� �������� �������� <b><%=AddUtil.ChangeDate2(im_rent_end_dt)%></b>�Դϴ�. ���簡 ���� �ʽ��ϴ�. �������� ������û�Ͻʽÿ�.</font>
			<%}else{%>
			&nbsp;
			<%}%>
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">����</td>
                    <td class=title width=15%>������</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%>-<%//=doc.getUser_nm3()%></td>
                    <td class=title width=15%>-<%//=doc.getUser_nm4()%></td>
                    <td class=title width=15%>-<%//=doc.getUser_nm5()%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></td>
                    <td align="center"><!--��������--><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
        			<%	if(doc.getUser_dt2().equals("")){
        			  		String user_id2 = doc.getUser_id2();%>
        			  <%	if(user_id2.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("����/�°�����",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id)){%>
					  <%		if(im_rent_end_dt.equals(im.getRent_end_dt())){%>
        			    <a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%		}%>
					  <%	}%>
        			    <br>&nbsp;
					  <%}%>
        			</td>
                    <td align="center"><!--ȸ������--><!--<%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
        			  <%if(doc.getUser_dt3().equals("")){
        			  		String user_id3 = doc.getUser_id3();%>
        			  <%	if(user_id3.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id)){%>
        			    <a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>-->
        			</td>
                    <td align="center"></td>
                    <td align="center"></td>			
        	    </tr>	
    		</table>
	    </td>
	</tr>  	  	
	<tr>
	    <td class=h></td>
	</tr>	
<%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) || doc.getUser_dt3().equals(user_id)){%> 	
<%		
		if(rtn_size == 0){
			Hashtable ht = new Hashtable();
			ht.put("FIRM_NM", client.getFirm_nm());
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
                </tr>
            </table>
        </td>
    </tr>	
<%			}%>
<%			//�����۾�������-����
			Vector fee_scd = ScdMngDb.getFeeScdTaxScd("", "3", ext_fee.getRent_st(), "", "", rent_mng_id, rent_l_cd, base.getCar_mng_id(), "", String.valueOf(r+1));
			int fee_scd_size = fee_scd.size();
			if(fee_scd_size>0){%>  	
    <tr></tr><tr></tr>		
	<tr>
	    <td colspan="2" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>	 
                <tr>
                    <td width='5%' rowspan="2" class='title'>ȸ��</td>
                    <td colspan="2" rowspan="2" class='title'>���Ⱓ</td>
                    <td width="13%" rowspan="2" class='title'>���뿩��</td>
                    <td width="5%" rowspan="2" class='title'>û��<br>/�Ա�</td>
                    <td width="5%" rowspan="2" class='title'>��ü</td>
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
							if(String.valueOf(ht.get("PAY_CNG_CAU")).equals("���ǿ���"+doc.getDoc_id())){
								total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("FEE_AMT")));%>
                <tr>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=j+1%></td>
                    <td width="8%" align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="8%" align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td align="right"  <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��&nbsp;&nbsp;</td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=ht.get("BILL_YN")%>/<%if(String.valueOf(ht.get("RC_YN")).equals("0")) 			out.println("N");
                     				 	else if(String.valueOf(ht.get("RC_YN")).equals("1"))   	out.println("Y");%>
                    </td>
                    <td align="right"  <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=ht.get("DLY_DAYS")%>��&nbsp;</td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%><%if(String.valueOf(ht.get("ITEM_DT")).equals("")&&nm_db.getWorkAuthUser("ȸ�����",user_id)){%><a href="javascript:dt_update('<%=ht.get("FEE_EST_DT")%>')"></a>.<%}%></td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ITEM_DT")))%></td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_EST_DT")))%></td>										
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>>
        		    <%if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
          		    <%}else{%>					
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
					<%}%>
        		    </td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>>
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
				<%			}%>
        <%				}%>
		        <tr>
				  <td class="title" colspan="3">�հ�</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��&nbsp;</td>
				  <td class="title" colspan="9"></td>				  
				</tr>		
            </table>
	    </td>
    </tr>
	<!--
	<tr>
	    <td colspan="2">* ���ǿ��� �������� ȸ�������� ������� ����մϴ�.</td>	
	</tr>	  	
	<tr>
	    <td colspan="2" align="right">
		<%if(nm_db.getWorkAuthUser("ȸ�����",user_id)){%> 
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'fee_amt');"><img src=/acar/images/center/button_ch_fee.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'req_dt');"><img src=/acar/images/center/button_ch_pub.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;    
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'tax_out_dt');"><img src=/acar/images/center/button_ch_tax.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp;
		  <span class="b"><a href="javascript:cng_schedule('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'fee_est_dt');"><img src=/acar/images/center/button_ch_dep.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 
		  <span class="b"><a href="javascript:cng_schedule2('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'use_dt');"><img src=/acar/images/center/button_ch_use.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 		  
		  <%if(rtn_size==1){%>	
		  <span class="b"><a href="javascript:cng_schedule3('<%=String.valueOf(r+1)%>', '<%=ext_fee.getRent_st()%>', 2, 'fee_amt');"><img src=/acar/images/center/button_dyrbh.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 		  
		  <%}%>
		<%}%>		  
	    </td>
	</tr>		  
	-->
<%			}%>  
<%		}%>
<%	}%>

	<%if(nm_db.getWorkAuthUser("������",user_id)){%>
	<tr>
	    <td class=h></td>
	</tr>		
    <tr>
		<td align="right">
		  <%if(!doc.getDoc_step().equals("3")){%> 	
		  &nbsp;<%=doc.getDoc_no()%>&nbsp;<%=doc.getDoc_id()%>
		  <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
		  <%}%>	
		</td>
	</tr>	
	<%}%>
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
