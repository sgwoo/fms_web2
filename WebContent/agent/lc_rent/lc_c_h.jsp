<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.estimate_mng.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();	
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�������뿩����
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�������뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//����ȸ������
	int in_size 			= af_db.getYnCarCallIn(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, String.valueOf(fee_size));
	
	//���°� Ȥ�� ���������϶� ����� ��������
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
	//��������
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	//��������-�������̺� ���� ��ȸ
	Hashtable carbase = shDb.getBase(base.getCar_mng_id(), max_fee.getRent_end_dt());
	
	// ����� ���� ��ȸ
	String dept_id = "";
	if(!user_id.equals("")){
		UserMngDatabase umd = UserMngDatabase.getInstance();
		UsersBean user_bean 	= umd.getUsersBean(user_id);
		
		dept_id = user_bean.getDept_id();
	}
	
	String valus = 	"?user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+fee_size+"&from_page="+from_page+"&now_stat="+now_stat;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����Ʈ
	function list(){
		var fm = document.form1;	
		if(fm.from_page.value != '') 	fm.action = fm.from_page.value;
		else 				fm.action = 'lc_s_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	

	//�ϴ������� ����
	function display_c(st){
		var fm = document.form1;	
		fm.action = 'lc_c_c_'+st+'.jsp';
		if(st == 'suc_commi') fm.action = '/fms2/lc_rent/lc_c_c_'+st+'.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}
	
	//��� ���ں� ��������
	function display_h_in(idx){
		var fee_size = <%=fee_size%>;
		
		head_cont.tr_cont.style.display 		= 'none';		
		head_cont.tr_pur.style.display 			= 'none';
		head_cont.tr_car.style.display 			= 'none';
		head_cont.tr_taecha.style.display 		= 'none';
		<%for(int i=0; i<fee_size; i++){%>
		head_cont.tr_fee<%=i+1%>.style.display 	= 'none';
		<%}%>		
		head_cont.tr_cls.style.display 			= 'none';
				
		if(idx == 'cont'){
			head_cont.tr_cont.style.display 	= '';
		}else if(idx == 'pur'){
			head_cont.tr_pur.style.display 		= '';		
		}else if(idx == 'car'){
			head_cont.tr_car.style.display 		= '';
		}else if(idx == 'taecha'){
			head_cont.tr_taecha.style.display 	= '';
		<%for(int i=0; i<fee_size; i++){%>
		}else if(idx == 'fee<%=i+1%>'){
			head_cont.tr_fee<%=i+1%>.style.display 	= '';
		<%}%>	
		}else if(idx == 'cls'){
			head_cont.tr_cls.style.display 		= '';
		}else{
			head_cont.tr_cont.style.display 	= '';		
		}
	}
	
	//�� ����
	function view_client()
	{
		window.open("/agent/client/client_c.jsp?user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id=<%=base.getClient_id()%>", "CLIENT", "left=10, top=10, width=900, height=700, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/agent/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		


	//��ĵ���� ����
	function view_scan(m_id, l_cd){
		window.open("scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}

	
	//�뿩��޸�
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0&memo_st=l_cd", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");						
	}		
	
	//�������
	function add_rent_esti_s(){
		window.open("/fms2/lc_rent/search_car_esti_s.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_ESTI_S", "left=0, top=0, width=1100, height=750, status=yes, scrollbars=yes");	
	}	
	
	// Ȯ�μ� ��� �˾� 2018.1.2
	function view_confirm_popup(){
		var rent_mng_id = '<%=rent_mng_id%>';
		var rent_l_cd = '<%=rent_l_cd%>';
		var car_mng_id = '<%=base.getCar_mng_id()%>';
		var url = "./lc_c_h_confirm_popup.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&car_mng_id="+car_mng_id;
		window.open(url,"CONFIRM_POPUP", "left=0, top=0, width=660, height=350, scrollbars=yes");
	}
	
		//�ߵ���������  ����
	function view_settle(m_id, l_cd){
	
		alert("���� ���� ���꼭 �Դϴ�. �� ����ݰ� ���̰� ���� �� �ֽ��ϴ�. !!!!");
		alert("�ʰ�����δ���� �ݿ����� �ʽ��ϴ�. ���������ϸ޴����� Ȯ���ϼ���.!!!!");
	
		<%if(base.getCar_st().equals("4")){%>
		window.open("/acar/cls_con/cls_settle_rm.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");	
		<%} else {%>	
		window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
		<%} %>	
		
	}	
	
	//���ϰ��� ����
	function view_mail(m_id, l_cd){
		window.open("/acar/car_rent/rent_email_reg.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "RentDocEmail", "left=100, top=100, width=1000, height=700, scrollbars=yes, status=yes");		
	}	
	
	function view_kakao_contract(m_id, l_cd, car_comp_id) {
        window.open("/acar/kakao/alim_talk_contract.jsp?mng_id="+m_id+"&l_cd="+l_cd+"&car_comp_id="+car_comp_id+"&dept_id="+<%=dept_id%>, "VIEW_KAKAO_CONTRACT", "left=0, top=0, width=800, height=750, scrollbars=yes");
	}	
	
	//�縮�� ��������
	function EstiReReg(){
		var fm = document.form1;
		fm.action = '/fms2/lc_rent/get_esti_mng_i_re_rent.jsp';
		fm.target = "_blank";
		fm.submit();
	}	
	
	// Ȯ�μ� ���ڹ���
	function view_confirm_edoc(){
		var url = "./confirm_doc_list.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=max_fee.getRent_st()%>";		
		window.open(url,"CONFIRM_POPUP", "left=0, top=0, width=760, height=450, scrollbars=yes, status=yes");
	}	
		
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15" <%if(base.getUse_yn().equals("N")){%>onLoad="javascript:display_h_in('cls');"<%}%>>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>   
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>     
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st" 		value="<%=fee_size%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="now_stat" 		value="<%=now_stat%>">  
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="cng_item"		value="">    
  <input type='hidden' name="est_st"		value="2">      
  <input type='hidden' name="fee_opt_amt"	value="<%=max_fee.getOpt_s_amt()+max_fee.getOpt_v_amt()%>">        
  <input type='hidden' name="fee_rent_st"	value="<%=max_fee.getRent_st()%>">    
<table border='0' cellspacing='0' cellpadding='0' width='100%'>	
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > ������ > <span class=style5>��༭����</span></span></td>
                    <td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	        <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){%><a href="javascript:display_c('suc_commi')">[���°�]</a> ����� : <%=begin.get("FIRM_NM")%>, �°����� : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%>, ���°������ : <%=AddUtil.parseDecimal(cont_etc.getRent_suc_commi())%>��, �������� : <%=begin.get("CLS_DT")%>, ������� : <%=base.getReg_dt()%> <%}%>
            	        <%if(String.valueOf(begin.get("CLS_ST")).equals("��������")){%>[��������] ����� : <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, �������� : <%=begin.get("CLS_DT")%>, ������� : <%=base.getReg_dt()%><%}%>            	    
			</font>&nbsp;
			<%if(in_size > 0){%><span class=style5>[����ȸ������]</span><%}%>
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
        <td colspan="2" align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <!-- <tr>
        <td class=line2></td>
    </tr> -->
    <tr>
        <td align=right>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                            <tr> 
                                <td class=title width=13%>����ȣ</td>
                                <td width=21%>&nbsp;<%=rent_l_cd%></td>
                                <td class=title width=10%>��ȣ</td>
                                <td width=22%>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%></a></td>
                                <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>����<%}else{%>������ȣ<%}%></td>
                                <td width=25%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a>
                    			&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>                    			
                    		</td>
                            </tr>
                		</table>
            	    </td>
            	</tr>
            </table>
        </td>
	    <td width=7>&nbsp;</td>
	</tr> 
	<tr>
        <td class=h></td>
    </tr> 	  	
	<%	int height = 142;%>
    <tr> 
        <td colspan="2">
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
    	        <tr>
        	    <td width=31%>
        		<iframe src="lc_c_h_dt.jsp<%=valus%>" name="head_dt" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                	</iframe>
        	    </td>
        	    <td width=2%>&nbsp;</td>
        	    <td width=67%>
        		<iframe src="lc_c_h_in.jsp<%=valus%>" name="head_cont" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                	</iframe>	
        	    </td>
    		</tr>
    	    </table>
	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td colspan="2" style='background-color:e3e3e3; height:1'></td>
	</tr>
    <!-- <tr>
        <td></td>
    </tr> -->		
	<tr>
	    <td colspan="2" align="center">
    	        <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
        		<td width='5%'>&nbsp;</td>
        		<td width='50%'>
        		    <table border="0" cellspacing="0" cellpadding="0" width=100%>			    		  
                        	<tr>
                          	    <td align="center">
                            		<a href="javascript:display_c('client')"><img src=/acar/images/center/button_cnt_cust.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                            		<a href="javascript:display_c('car')"><img src=/acar/images/center/button_cnt_carins.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                            		<a href="javascript:display_c('fee')"><img src=/acar/images/center/button_cnt_lend.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                            		<a href="javascript:display_c('gur')"><img src=/acar/images/center/button_cnt_cghb.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                            		<a href="javascript:display_c('emp')"><img src=/acar/images/center/button_cnt_sman.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                                        <a href="javascript:display_c('tint')"><img src=/acar/images/center/button_p_yp.gif align=absmiddle border=0></a>&nbsp;
			    		<a href="javascript:display_c('etc')"><img src=/acar/images/center/button_p_sp.gif align=absmiddle border=0></a>
			  	    </td>
        			</tr>
        		    </table>
        		</td>
        		<td width='45%' style='text-align=center'>
        			  
        			  <a href="javascript:view_kakao_contract('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=cm_bean.getCar_comp_id()%>');" class="btn" title='�˸���'><img src=/acar/images/center/button_ntalk.gif align=absmiddle border=0></a>&nbsp;
        			  
        			  <a href="javascript:view_memo('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='��ȭ��������'><img src=/acar/images/center/button_th.gif align=absmiddle border=0></a>&nbsp;&nbsp;

        		    <a href="javascript:view_mail('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='�ȳ������Ϲ߼�'><img src=/acar/images/center/button_mail.gif align=absmiddle border=0></a>&nbsp;
        		    
        		    <a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='��ĵ����'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        		    
        			    <%if(base.getBus_id().equals(ck_acar_id)){%>
                        <%		if(!base.getUse_yn().equals("N")){%>
                        <!-- �����ϱ� -->
                        <a href="javascript:view_settle('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='�����ϱ�'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			            <!-- ��������ϱ� -->
			            <%			if(ck_acar_id.equals("000178") || ck_acar_id.equals("000253")){ //���������  ������ ����, ��ȣ�� ���常%>
			            <a href="javascript:add_rent_esti_s();" class="btn" title='��������ϱ�'><img src=/acar/images/center/button_est_yj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			            <%			}%>
			            <%		}%>
        			    <!-- ���������� �����ٽó��� -->
			            <%		if(base.getUse_yn().equals("Y") && base.getCar_gu().equals("1") && cont_etc.getRent_suc_dt().equals("") && fee_size==1 && !base.getCar_mng_id().equals("") && !base.getRent_start_dt().equals("")){%>
			            <%			if(ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//����,���Ҵ� ����.%>
			            <%			}else{ %>
                        <!--<input type="button" class="button" value="���������� ���� �ٽó���" onclick="javascript:EstiReReg();">&nbsp;-->
                        <input type="button" class="button" value="���������� �����Ÿ� ����" onclick="javascript:EstiReReg();">&nbsp;
                        <%			} %>
                        <%		} %>
        			    <%}%> 
        			  

        			  
        			<!-- Ȯ�μ� ��� 2018.1.2        			
					<a href="javascript:view_confirm_popup();" class="btn"><img src=/acar/images/center/button_confirm.gif align=absmiddle border=0></a>
					-->
					
					
					
					<input type="button" class="button" value="����Ȯ�μ�" onclick="javascript:view_confirm_edoc();">&nbsp;
					
					
       			</td>						
    		    </tr>
    		</table>
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
