<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.* "%>
<%@ page import="acar.settle_acc.*, acar.cls.*, acar.fee.*, acar.cont.*,acar.client.*, acar.credit.*, acar.doc_settle.*, acar.ext.*, acar.res_search.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="acr_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String today = request.getParameter("today")==null?AddUtil.getDate():request.getParameter("today");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	String page_st = request.getParameter("page_st")==null?"":request.getParameter("page_st");
	
	String cls_use_mon 	= request.getParameter("cls_use_mon")==null?"":request.getParameter("cls_use_mon");
	String bad_amt 		= request.getParameter("bad_amt")==null?"":request.getParameter("bad_amt");
	int    seq		= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String doc_no 		= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	String use_end_dt = "";
	String accid_id = "";
	String serv_id = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "07", "03");
	
	//�������
	Hashtable ht = s_db.getContSettleInfo(l_cd);
	
	if(client_id.equals("")) 	client_id 	= (String)ht.get("CLIENT_ID");
	if(m_id.equals("")) 		m_id 		= (String)ht.get("RENT_MNG_ID");
	if(c_id.equals("")) 		c_id 		= (String)ht.get("CAR_MNG_ID");
	
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	//��ü����
	ClientBean client = al_db.getClient(client_id);
	
	//�����Ƿ�����
	ClsEtcBean cls_etc = acr_db.getClsEtcCase(m_id, l_cd);
	
	//�����Ƿڻ������
	ClsEtcSubBean cls_etc_sub = acr_db.getClsEtcSubCase(m_id, l_cd, 1);
	
	RentContBean 	rc_bean 	= new RentContBean();
	RentCustBean 	rc_bean2 	= new RentCustBean();
	RentFeeBean 	rf_bean 	= new RentFeeBean();
	RentSettleBean 	rs_bean 	= new RentSettleBean();
	Hashtable 	reserv 		= new Hashtable();
	//������
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
		
	
	//����ý���(����Ʈ)
	if(!s_cd.equals("")){
	
		
		//��������
		reserv = rs_db.getCarInfo(c_id);
		//�ܱ�������
		rc_bean = rs_db.getRentContCase(s_cd, c_id);
		//������
		rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
		//�ܱ�뿩����
		rf_bean = rs_db.getRentFeeCase(s_cd);
		//�ܱ�뿩��������
		rs_bean = rs_db.getRentSettleCase(s_cd);
		
		if(rc_bean.getRent_st().equals("12")){
			m_id 	= c_id;
			l_cd 	= "RM00000"+s_cd;
			client_id = rc_bean.getCust_id();
		}
					
	}
	
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettleCommi("46", l_cd+""+String.valueOf(seq));
	if(doc_no.equals("")){
		doc_no = doc.getDoc_no();
	}
	
	//�����
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	//��û���� �� ó������ ����
	BadDebtReqBean bad_debt = a_db.getBadDebtReq(m_id, l_cd, seq);
	
	//���ó����û����Ʈ
	Vector item_vt = a_db.getBadDebtReqItemList(doc.getDoc_id());
	int item_vt_size = item_vt.size();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 20; //��Ȳ ��� �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	//���⺻����
	ContBaseBean c_base = a_db.getCont(m_id, l_cd);
	//���°� Ȥ�� ���������϶� ����� ��������
	Hashtable begin = a_db.getContBeginning(m_id, c_base.getReg_dt());
	//���°� Ȥ�� ���������϶� �°��� ��������
	Hashtable cng_cont = af_db.getScdFeeCngContA(m_id, l_cd);
	
	long total_amt 	= 0;
	long total_s_amt 	= 0;
	long total_v_amt 	= 0;
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		<%if(page_st.equals("settle_acc")){%>	
		fm.action = '/acar/settle_acc/settle_s_frame.jsp';		
		<%}else{%>
		fm.action = '/fms2/settle_acc/bad_debt_doc_frame.jsp';		
		<%}%>	
		fm.mode.value = '';
		fm.target = 'd_content';	
		fm.submit();
	}	
	
	//�� ����
	function view_client(){
		var m_id = document.form1.m_id.value;		
		var l_cd = document.form1.l_cd.value;			
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}	

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			
	
	//�����ϱ�
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		if(doc_bit == '1'){
			if(fm.bad_debt_cau.value == '')	{ alert('��û������ �Է��Ͻʽÿ�.'); 				return; }
		}else if(doc_bit == '2'){
			if(fm.bad_debt_st.value == '')	{ alert('ó�������� �����Ͻʽÿ�.'); 				return; }		
		}
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='bad_debt_doc_sanction.jsp';		
			fm.target='i_no';
			fm.target='_blank';
			fm.submit();
		}									
	}
	
	//����� �����ϱ�
	function bad_debt_busid2_cng(){
		var fm = document.form1;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='bad_debt_busid2_cng_a.jsp';		
			fm.target='i_no';
			fm.target='_blank';
			fm.submit();
		}							
	}
	
	//���ó���ϱ�
	function bad_debt_dir_action(){
		var fm = document.form1;
		
		if(confirm('ó���Ͻðڽ��ϱ�?')){	
			fm.action='bad_debt_dir_action_a.jsp';		
			fm.target='i_no';
			fm.target='_blank';
			fm.submit();
		}				
	}
	
	//�Ⱒ�ϴ� �������̱�
	function display_reject(){
		var fm = document.form1;
		
		if(fm.bad_debt_st.value =='3'){ //�Ⱒ
			tr_reject.style.display	= '';
		}else{							//����
			tr_reject.style.display	= 'none';
		}
	}
	
	function view_memo()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;		
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var r_st = '1';						
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st+"&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750");		
	}	
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}		
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='bad_debt_doc_sanction.jsp' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
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
<input type='hidden' name='page_st' value='<%=page_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='seq' 		value='<%=seq%>'>
<input type='hidden' name="doc_no" 		value="<%=doc_no%>">
<input type='hidden' name="doc_bit" 	value="">
<input type='hidden' name="car_no" 		value="<%=ht.get("CAR_NO")%>">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > �̼������� ���� > <span class=style5>ä�� ���ó�� ��û</span></span></td>
					<td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>[���°�] ����� : <%=begin.get("RENT_L_CD")%> <%=begin.get("FIRM_NM")%>, �°����� : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%> <%}%>
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("��������")){%>[��������] ����� : <%=begin.get("RENT_L_CD")%> <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, �������� : <%=begin.get("CLS_DT")%><%}%>            	    
					
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5")){%>[���°�] �°��� : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, �°����� : <%if(String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("")){%><%=cng_cont.get("CLS_DT")%><%}else{%><%=cng_cont.get("RENT_SUC_DT")%><%}%> <%if(!String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("") && !String.valueOf(cng_cont.get("RENT_SUC_DT")).equals(String.valueOf(cng_cont.get("CLS_DT")))){%>, �������� : <%=cng_cont.get("CLS_DT")%><%}%> <%}%>
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>[��������] ������ : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, �������� : <%=cng_cont.get("CLS_DT")%> <%}%>					
					</font>&nbsp;
					</td>	
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align='right'><a href='javascript:go_to_list()'><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
	    <a href='javascript:history.go(-1);'><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a>	  
	    </td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%if(m_id.equals(c_id) && !s_cd.equals("")){%>
                <input type='hidden' name="firm_nm" 	value="<%=rc_bean2.getFirm_nm()%>">
                <tr> 
                    <td width=10% class='title'>����ȣ</td>
                    <td width=23%>&nbsp;<%=rc_bean.getRent_s_cd()%>
                        <%if(rc_bean.getRent_st().equals("1")){%>
                    �ܱ�뿩 
                    <%}else if(rc_bean.getRent_st().equals("2")){%>
                    ������� 
                    <%}else if(rc_bean.getRent_st().equals("3")){%>
                    ������ 
                    <%}else if(rc_bean.getRent_st().equals("9")){%>
                    ������� 		
                    <%}else if(rc_bean.getRent_st().equals("10")){%>
                    �������� 				
                    <%}else if(rc_bean.getRent_st().equals("4")){%>
                    �����뿩 
                    <%}else if(rc_bean.getRent_st().equals("5")){%>
                    �������� 
                    <%}else if(rc_bean.getRent_st().equals("6")){%>
                    �������� 
                    <%}else if(rc_bean.getRent_st().equals("7")){%>
                    �������� 
                    <%}else if(rc_bean.getRent_st().equals("8")){%>
                    ������ 
                    <%}else if(rc_bean.getRent_st().equals("11")){%>
                    ��Ÿ 
                    <%}else if(rc_bean.getRent_st().equals("12")){%>
                    ����Ʈ
                    <%}%>
                    </td>
                    <td width=10% class='title'>���������</td>
                    <td width=23%>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(),"USER")%></td>
                    <td width=10% class='title'>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getMng_id(),"USER")%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<font color="#000099"><b><%=reserv.get("CAR_NO")%></b></font></td>
                    <td class='title'>����</td>
                    <td >&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
                    <td class='title'>�����</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                </tr>  
                <tr> 
                    <td class='title'>��ȣ</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>�����Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class='title'>�����Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                    <td class='title'>�ѻ��Ⱓ</td>
                    <td>&nbsp;<%=rs_bean.getTot_months()%>����<%=rs_bean.getTot_days()%>��</td>
                </tr>       						                                          
                <%}else{%>
                <input type='hidden' name="firm_nm" 	value="<%=ht.get("FIRM_NM")%>">
                <tr> 
                    <td class='title'>����ȣ</td>
                    <td>&nbsp;<%=ht.get("RENT_L_CD")%></td>
                    <td class='title'>���������</td>
                    <td colspan="5">&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("BUS_ID2")),"USER")%></td>
                </tr>
                <tr> 
                    <td class='title'>��ȣ</td>
                    <td>&nbsp;<a href="javascript:view_client('<%=m_id%>', '<%=l_cd%>', '1')" onMouseOver="window.status=''; return true"><%=ht.get("FIRM_NM")%></a></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=ht.get("CLIENT_NM")%></td>
                    <td class='title'>�뿩����</td>
                    <td colspan="3">&nbsp;<%=ht.get("CAR_NM")%> <%=ht.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<font color="#000099"><b><%=ht.get("CAR_NO")%></b></font></td>
                    <td class='title'>�����</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
                    <td class='title'>�뿩�Ⱓ</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>&nbsp;~&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                </tr>
                <tr> 
                    <td class='title'>�Ѵ뿩�Ⱓ</td>
                    <td >&nbsp;<%=ht.get("CON_MON")%>����</td>
                    <td class='title'>���̿�Ⱓ</td>
                    <td>&nbsp;<%=ht.get("U_MON")%>����&nbsp;<%=ht.get("U_DAY")%>��</td>
                    <td class='title'>�뿩���</td>
                    <td colspan="3">&nbsp;<%=ht.get("RENT_WAY")%></td>
                </tr>
                <tr> 
                    <td class='title' width=10%>���뿩��</td>
                    <td width=18%>&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht.get("FEE_AMT")))%> 
                      ��&nbsp;</td>
                    <td class='title' width=10%>�����ݾ�</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht.get("PP_AMT1")))%> 
                      ��&nbsp;</td>
                    <td width=10% class='title'>�����ݾ�</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht.get("PP_AMT2")))%> 
                      ��&nbsp;</td>
                    <td width=10% class='title'>���ô뿩��</td>
                    <td width=12%>&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht.get("PP_AMT3")))%> 
                      ��&nbsp;</td>
                </tr>
		<%if(!String.valueOf(ht.get("CLS_DT")).equals("")){%>
                <tr> 
                    <td class='title'>�������� </td>
                    <td> &nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%> 
						<%if(!cls_use_mon.equals("")){%>
						[���������:<%=cls_use_mon%>����]
						<%}%>
					</td>
                    <td class='title'>�������� </td>
                    <td> &nbsp;<%=ht.get("CLS_ST_NM")%></td>
                    <td class='title'>��������</td>
                    <td colspan="3"> &nbsp;<%=ht.get("CLS_CAU")%> </td>
                </tr>
		<%}%>
                <%}%>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̼� ä�� </span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=5% class='title'>����</td>								
                    <td width=10% class='title'>����</td>				
                    <td width=10% class='title'>�Աݿ�����</td>
                    <td width=10% class='title'>���ް�</td>
                    <td width=10% class='title'>�ΰ���</td>
                    <td width=10% class='title'>�հ�</td>
                    <td width=45% class='title'>���</td>									
                </tr>	
<% int count = 0;%>		



<%if(doc.getDoc_id().equals("")){%>


<%
	//�����ݸ���Ʈ
	Vector pre_lists = s_db.getPreList(m_id, l_cd, client_id, mode, gubun2, today);
	int pre_size = pre_lists.size();
	if(pre_size > 0){
		for (int i = 0 ; i < pre_size ; i++){
			Hashtable item_ht = (Hashtable)pre_lists.elementAt(i);
			count++;
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>				  
				<input type='hidden' name='item_gubun' value='<%=item_ht.get("ST")%>'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("EXT_ST")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("EXT_TM")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("EXT_ID")%>'>
				<input type='hidden' name='item_cd5' value=''>
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>
                <tr> 
                    <td align="center"><%=count%></td>
					<td align="center"><%=item_ht.get("ST")%>  <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/grt_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a></td>										
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>��</td>
                    <td>&nbsp;
					<%if(!String.valueOf(item_ht.get("EXT_TM")).equals("1") && !String.valueOf(item_ht.get("ST")).equals("�°������")){
							//�����뿩����
							ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, String.valueOf(item_ht.get("RENT_ST")));
							int ext_base_amt = 0;
							if(String.valueOf(item_ht.get("ST")).equals("������")){
								ext_base_amt = fee.getGrt_amt_s();
							}else if(String.valueOf(item_ht.get("ST")).equals("������")){
								ext_base_amt = fee.getPp_s_amt()+fee.getPp_v_amt();
							}else if(String.valueOf(item_ht.get("ST")).equals("���ô뿩��")){
								ext_base_amt = fee.getIfee_s_amt()+fee.getIfee_v_amt();
							}
						%>
						<input type='hidden' name='etc' value='�ѱݾ� <%=AddUtil.parseDecimal(ext_base_amt)%>���� <%=Util.parseDecimal(ext_base_amt-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>�� �Ա�'>
						<font color=green>�ѱݾ� <%=AddUtil.parseDecimal(ext_base_amt)%>���� <%=Util.parseDecimal(ext_base_amt-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>�� �Ա�</font>
					<%}else{%>
						<input type='hidden' name='etc' value=''>
					<%}%>
					</td>
                </tr>
<%		}
	}%>	
	
<%	if(String.valueOf(ht.get("CLS_ST_NM")).equals("���°�")){%>
<%		//�뿩�Ḯ��Ʈ
		Vector fee_lists = s_db.getFeeList(m_id, l_cd, client_id, mode, gubun2, today);
		int fee_size = fee_lists.size();
		if(fee_size > 0){
			for (int i = 0 ; i < fee_size ; i++){
				Hashtable item_ht = (Hashtable)fee_lists.elementAt(i);
				count++;
			
				total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
				total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
				total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>				  
				<input type='hidden' name='item_gubun' value='<%=item_ht.get("ST")%>'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("RENT_SEQ")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("TM")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("TM_ST1")%>'>
				<input type='hidden' name='item_cd5' value=''>
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>
                <tr> 
                    <td align="center"><%=count%></td>
					<td align="center"><%=item_ht.get("ST")%>  <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/grt_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a></td>										
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>��</td>
                    <td>&nbsp;<input type='hidden' name='etc' value=''></td>
                </tr>
<%			}
		}%>
<%		//��ü����
		Vector fee_dly_lists = s_db.getFeeDlyList(m_id, l_cd, client_id, mode, gubun2, today);
		int fee_dly_size = fee_dly_lists.size();
		
		
		if(fee_dly_size > 0){
			for (int i = 0 ; i < fee_dly_size; i++){
				Hashtable item_ht = (Hashtable)fee_dly_lists.elementAt(i);
				count++;
			
				total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("DLY_AMT")));				
				total_amt   = total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("DLY_AMT")));
%>				  
				<input type='hidden' name='item_gubun' value='<%=item_ht.get("ST")%>'>
				<input type='hidden' name='item_cd1' value=''>
				<input type='hidden' name='item_cd2' value=''>
				<input type='hidden' name='item_cd3' value=''>
				<input type='hidden' name='item_cd4' value=''>
				<input type='hidden' name='item_cd5' value=''>
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value=''>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("DLY_AMT")%>'>
				<input type='hidden' name='v_amt' value='0'>
				<input type='hidden' name='amt' value='<%=item_ht.get("DLY_AMT")%>'>
                <tr> 
                    <td align="center"><%=count%></td>
		    <td align="center"><%=item_ht.get("ST")%></td>
                    <td align="center"></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("DLY_AMT")))%>��</td>
                    <td align="right">0��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("DLY_AMT")))%>��</td>
                    <td>&nbsp;<input type='hidden' name='etc' value=''></td>
                </tr>
<%			}
		}%>		
	
<%	}%>



<%
	//���·Ḯ��Ʈ
	Vector fine_lists = s_db.getFineList(m_id, l_cd, client_id, mode, gubun2, today);
	int fine_size = fine_lists.size();
	if(fine_size > 0){
		for (int i = 0 ; i < fine_size ; i++){
			Hashtable item_ht = (Hashtable)fine_lists.elementAt(i);
			count++;
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>			
				<input type='hidden' name='item_gubun' value='���·�'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("SEQ_NO")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("RENT_L_CD")%>'>
				<input type='hidden' name='item_cd5' value=''>								
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>
	  
                <tr> 
                    <td align="center"><%=count%></td>								
				    <td align="center">���·� <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/fine_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=item_ht.get("SEQ_NO")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a></td>		
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>	
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>��</td>
                    <td align="right"></td>														
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>��</td>
                    <td>&nbsp;[<%=item_ht.get("ST")%>] û�����:<%=item_ht.get("GOV_NM")%> | �������:<%=item_ht.get("VIO_PLA")%><br>&nbsp;��������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("VIO_DT")))%> | ��������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("PROXY_DT")))%> | û������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("DEM_DT")))%>
					<input type='hidden' name='etc' value='[<%=item_ht.get("ST")%>] û�����:<%=item_ht.get("GOV_NM")%> | �������:<%=item_ht.get("VIO_PLA")%><br>&nbsp;��������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("VIO_DT")))%> | ��������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("PROXY_DT")))%> | û������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("DEM_DT")))%>'>
					</td>					
                </tr>
<%		}
	}%>		
			
<%
	//�ߵ���������ݸ���Ʈ
	Vector cls_lists = s_db.getClsList(m_id, l_cd, client_id, mode, gubun2, today);
	int cls_size = cls_lists.size();
	
	if(cls_size > 0){
		for (int i = 0 ; i < cls_size ; i++){
			Hashtable item_ht = (Hashtable)cls_lists.elementAt(i);
			count++;
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>			
				<input type='hidden' name='item_gubun' value='���������'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("EXT_ST")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("EXT_TM")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("EXT_ID")%>'>
				<input type='hidden' name='item_cd5' value=''>								
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>
	  
                <tr> 
                    <td align="center"><%=count%></td>								
                    <td align="center">��������� <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/cls_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a> 
					</td>				
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>��</td>
                    <td>
						<%if(i==0){%>
							<table width="100%" border="0">
								<%if(String.valueOf(item_ht.get("ST")).equals("�ܾ�")){%>
								<tr>
									<td colspan='3'><font color=green>�ѱݾ� <%=AddUtil.parseDecimal(cls_etc.getFdft_amt2())%>���� <%=Util.parseDecimal(cls_etc.getFdft_amt2()-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>�� �Ա�</font>
									<input type='hidden' name='etc' value='�ѱݾ� <%=AddUtil.parseDecimal(cls_etc.getFdft_amt2())%>���� <%=Util.parseDecimal(cls_etc.getFdft_amt2()-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>�� �Ա�'>
									</td>
								</tr>
								<%}else{%>
								<input type='hidden' name='etc' value=''>
								<%}%>
							</table>												
						<%}else{%>
						<input type='hidden' name='etc' value=''>
						<%}%>
					</td>					
                </tr>
<%		}
	}%>		
	
	
<%
	//��å�ݸ���Ʈ
	Vector serv_lists = s_db.getServList(m_id, l_cd, client_id, mode, gubun2, today);
	int serv_size = serv_lists.size();
	if(serv_size > 0){
		for (int i = 0 ; i < serv_size ; i++){
			Hashtable item_ht = (Hashtable)serv_lists.elementAt(i);
			count++;
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>				  
				<input type='hidden' name='item_gubun' value='��å��'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("EXT_ST")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("EXT_TM")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("EXT_ID")%>'>
				<input type='hidden' name='item_cd5' value='<%=item_ht.get("ACCID_ID")%>'>								
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>

                <tr> 
                    <td align="center"><%=count%></td>								
				    <td align="center">��å�� <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/accid_c7.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&serv_id=<%=item_ht.get("SERV_ID")%>&accid_id=<%=item_ht.get("ACCID_ID")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a></td>		
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>��</td>										
                    <td>&nbsp;
						<%if(!String.valueOf(item_ht.get("EXT_TM")).equals("1")){%>
								<font color=green>�ѱݾ� <%=Util.parseDecimal(String.valueOf(item_ht.get("CUST_AMT")))%>���� <%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item_ht.get("CUST_AMT")))-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>�� �Ա�</font>
								<input type='hidden' name='etc' value='�ѱݾ� <%=Util.parseDecimal(String.valueOf(item_ht.get("CUST_AMT")))%>���� <%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item_ht.get("CUST_AMT")))-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>�� �Ա�'>
						<%}else{%>
					    [<%=item_ht.get("ST")%>] �����ü:<%=item_ht.get("OFF_NM")%> | ��������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("SERV_DT")))%> | ����ݾ�:<%=Util.parseDecimal(String.valueOf(item_ht.get("REP_AMT")))%>��
						<input type='hidden' name='etc' value='[<%=item_ht.get("ST")%>] �����ü:<%=item_ht.get("OFF_NM")%> | ��������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("SERV_DT")))%> | ����ݾ�:<%=Util.parseDecimal(String.valueOf(item_ht.get("REP_AMT")))%>��'>
						<%}%>
					</td>
                </tr>
<%		}
	}%>		

	

<!--	
	
<%
	//��/������ ����Ʈ
	Vector accid_lists = s_db.getAccidList(m_id, l_cd, client_id, mode, gubun2, today);
	int accid_size = accid_lists.size();
	if(accid_size > 0){
		for (int i = 0 ; i < accid_size ; i++){
			Hashtable item_ht = (Hashtable)accid_lists.elementAt(i);
			count++;
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>				  
				<input type='hidden' name='item_gubun' value='������'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("EXT_ST")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("EXT_TM")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("EXT_ID")%>'>
				<input type='hidden' name='item_cd5' value=''>								
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>

                <tr> 
                    <td align="center"><%=count%></td>								
                    <td align="center">������ <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/accid_c8.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=item_ht.get("SEQ_NO")%>&accid_id=<%=item_ht.get("ACCID_ID")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a></td>		
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>��</td>										
                    <td>&nbsp;
						<%if(!String.valueOf(item_ht.get("EXT_TM")).equals("1")){%>
								<font color=green>�ѱݾ� <%=Util.parseDecimal(String.valueOf(item_ht.get("REQ_AMT")))%>���� <%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item_ht.get("REQ_AMT")))-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>�� �Ա�</font>
								<input type='hidden' name='etc' value='�ѱݾ� <%=Util.parseDecimal(String.valueOf(item_ht.get("REQ_AMT")))%>���� <%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item_ht.get("REQ_AMT")))-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>�� �Ա�'>	
						<%}else{%>
					    		[<%=item_ht.get("ST")%>] �����:<%=item_ht.get("OT_INS")%> | �������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("ACCID_DT")))%> | û������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("REQ_DT")))%>
						<input type='hidden' name='etc' value='[<%=item_ht.get("ST")%>] �����:<%=item_ht.get("OT_INS")%> | �������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("ACCID_DT")))%> | û������:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("REQ_DT")))%>'>	
						<%}%>
					</td>
                </tr>
<%		}
	}%>	
	
-->	
	
<%
	//����Ʈ�����
	if(m_id.equals(c_id) && !s_cd.equals("")){
		Vector res_lists = s_db.getRentCont12List(c_id, s_cd, rc_bean.getCust_id(), mode, gubun2, today);
		int res_size = res_lists.size();
	
		if(res_size > 0){
			for (int i = 0 ; i < res_size ; i++){
				Hashtable item_ht = (Hashtable)res_lists.elementAt(i);
				count++;
			
				total_s_amt 	= total_s_amt 	+ AddUtil.parseLong(String.valueOf(item_ht.get("RENT_S_AMT")));
				total_v_amt 	= total_v_amt 	+ AddUtil.parseLong(String.valueOf(item_ht.get("RENT_V_AMT")));
				total_amt 	= total_amt 	+ AddUtil.parseLong(String.valueOf(item_ht.get("RENT_AMT")));
%>			
				<input type='hidden' name='item_gubun' value='����Ʈ�����'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("TM")%>'>
				<input type='hidden' name='item_cd3' value=''>
				<input type='hidden' name='item_cd4' value=''>
				<input type='hidden' name='item_cd5' value=''>								
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("RENT_S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("RENT_V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("RENT_AMT")%>'>
				<input type='hidden' name='etc' value=''>
	  
                <tr> 
                    <td align="center"><%=count%></td>								
                    <td align="center">����Ʈ����� <a class=index1 href="javascript:MM_openBrWindow('/acar/con_rent/res_fee_c.jsp?mode=view&c_id=<%=c_id%>&s_cd=<%=s_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a> 
					</td>				
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("RENT_S_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("RENT_V_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("RENT_AMT")))%>��</td>
                    <td>&nbsp;</td>					
                </tr>
<%			}
		}
	}%>				
	
<%}else{//�Ҿ�ä�� �׸� ����Ʈ%>	


<%	count = item_vt_size; %>

<%
		for(int i = 0 ; i < item_vt_size ; i++)
		{
			Hashtable item_ht = (Hashtable)item_vt.elementAt(i);
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>

				<input type='hidden' name='item_gubun' value='<%=item_ht.get("ITEM_GUBUN")%>'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("ITEM_CD1")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("ITEM_CD2")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("ITEM_CD3")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("ITEM_CD4")%>'>
				<input type='hidden' name='item_cd5' value='<%=item_ht.get("ITEM_CD5")%>'>								
				<input type='hidden' name='item_seq' value='<%=item_ht.get("SEQ")%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>
				<input type='hidden' name='etc' value='<%=item_ht.get("ETC")%>'>

                <tr> 
                    <td align="center"><%=item_ht.get("SEQ")%></td>								
                    <td align="center"><%=item_ht.get("ITEM_GUBUN")%>
						<%if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("������")||String.valueOf(item_ht.get("ITEM_GUBUN")).equals("������")||String.valueOf(item_ht.get("ITEM_GUBUN")).equals("���ô뿩��")||String.valueOf(item_ht.get("ITEM_GUBUN")).equals("�°������")){%>
							<a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/grt_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a>
						<%}else if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("���·�")){%>
							<a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/fine_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=item_ht.get("ITEM_CD1")%>&seq_no=<%=item_ht.get("ITEM_CD2")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a>
						<%}else if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("���������")){%>
							<a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/cls_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a>
						<%}else if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("��å��")){%>
							<a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/accid_c7.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&serv_id=<%=item_ht.get("ITEM_CD4")%>&accid_id=<%=item_ht.get("ITEM_CD5")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a>
						<%}else if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("������")){
								String i_accid_id = String.valueOf(item_ht.get("ITEM_CD4")).substring(0, 6);
								String i_seq_no   = String.valueOf(item_ht.get("ITEM_CD4")).substring(6);
								%>
							<a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/accid_c8.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=i_seq_no%>&accid_id=<%=i_accid_id%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a>
						<%}else if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("����Ʈ�����")){%>
						        <a class=index1 href="javascript:MM_openBrWindow('/acar/con_rent/res_fee_c.jsp?mode=view&c_id=<%=c_id%>&s_cd=<%=s_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a>
						<%}%>
					</td>		
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>��</td>										
                    <td>&nbsp;<%=item_ht.get("ETC")%></td>
                </tr>

<%		}%>

<%}%>
			
                <tr> 
                    <td class="title" colspan="3">�հ�</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_s_amt)%>��</td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_v_amt)%>��</td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��
					<input type='hidden' name="bad_amt" 		value="<%=total_amt%>">
					</td>													
                    <td class="title">&nbsp;</td>
                </tr>					  
            </table>
        </td>
    </tr>
    <tr>
        <td>* ���� ���� �̴� <img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0">�� Ŭ���ϸ� �󼼳��� Ȯ�� �����մϴ�.</td>
    </tr>			
    <tr>
        <td class=h></td>
    </tr>				
    <tr> 
        <td ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ó����û</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="10%">��û����</td>
                    <td>&nbsp;<textarea cols="100" rows="5" name="bad_debt_cau"><%=bad_debt.getBad_debt_cau()%></textarea></td>
                </tr>		
				<%if(!doc.getUser_dt1().equals("")){%>		
                <tr> 
                    <td class='title' width="10%">ó������</td>
                    <td>&nbsp;
                      <select name='bad_debt_st'  class='default' <%if(!doc.getUser_dt1().equals("")){%>onchange="javascript:display_reject();"<%}%> <%if(doc.getDoc_step().equals("3")){%>disabled<%}%> >
                        <option value="">����</option>
						<option value="1" <%if(bad_debt.getBad_debt_st().equals("1"))%>selected<%%>>����(ä���߽�)</option>
						<option value="2" <%if(bad_debt.getBad_debt_st().equals("2")||bad_debt.getBad_debt_st().equals(""))%>selected<%%>>����(���ó��)</option>
						<option value="3" <%if(bad_debt.getBad_debt_st().equals("3"))%>selected<%%>>�Ⱒ</option>
                      </select>
					</td>
                </tr>				
                <tr id=tr_reject style="display:<%if(bad_debt.getBad_debt_st().equals("3")){%>''<%}else{%>none<%}%>"> 
                    <td class='title' width="10%">�Ⱒ����</td>
                    <td>&nbsp;<textarea cols="100" rows="5" name="reject_cau"><%=bad_debt.getReject_cau()%></textarea></td>
                </tr>								
				<%}%>
           </table>
        </td>
    </tr>	
	<%if(!doc.getUser_dt2().equals("") && !bad_debt.getBad_debt_st().equals("3")){%>			
    <tr>
        <td class=h></td>
    </tr>				
    <tr> 
        <td ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ó�����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<%		if(bad_debt.getBad_debt_st().equals("1")){//ä���߽�%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="10%">ä���߽�</td>
                    <td>&nbsp;
                      <%=c_db.getNameById(bad_debt.getOld_bus_id2(),"USER")%> --> <%=c_db.getNameById(bad_debt.getNew_bus_id2(),"USER")%>
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  <%if(bad_debt.getBus_id2_cng_yn().equals("Y")){//����Ϸ�%>
					  [����Ϸ�] <%=bad_debt.getCng_dt()%> <%=c_db.getNameById(bad_debt.getCng_id(),"USER")%>
					  <%}else{%>
					  <%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)){%>
					  <a href="javascript:bad_debt_busid2_cng()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					  <%	}else{%>
					  ������� �ʾҽ��ϴ�.
					  <%	}%>
					  <%}%>
					</td>
                </tr>				
           </table>
        </td>
    </tr>		
	<%		}%>			
	<%		if(bad_debt.getBad_debt_st().equals("2")){//���ó��%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="10%">���ó��</td>
                    <td>&nbsp;
					  <%if(bad_debt.getBus_id2_cng_yn().equals("Y")){//����Ϸ�%>
					  [ó���Ϸ�] <%=bad_debt.getCng_dt()%> <%=c_db.getNameById(bad_debt.getCng_id(),"USER")%>
					  <%}else{%>
					  <%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)){%>
					  <a href="javascript:bad_debt_dir_action()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					  <%	}else{%>
					  ó������ �ʾҽ��ϴ�.
					  <%	}%>
					  <%}%>
					</td>
                </tr>				
           </table>
        </td>
    </tr>		
	<%		}%>					
	<%}%>				
    <tr>
        <td class=h></td>
    </tr>				
    <tr> 
        <td width="right" align="right">&nbsp;<a href="javascript:view_memo()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_tel.gif align=absmiddle border="0"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=10% rowspan="2">����</td>
                    <td class=title width=20%>������</td>					
                    <td class=title width=20%>�����</td>
                    <td class=title width=20%>�ѹ�����</td>
                    <td class=title width=30%>-</td>
                </tr>
                <tr>
                    <td align="center"><%=user_bean.getBr_nm()%></td>				
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("") && count>0 ){%><br><a href="javascript:doc_sanction('1');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id)){%><br><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
                    <td align="center"></td>
                </tr>
            </table>
	    </td>
    </tr>	
    <tr>
        <td>
                * doc_no : [<%=doc_no%>]
        </td>
    </tr>	
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
