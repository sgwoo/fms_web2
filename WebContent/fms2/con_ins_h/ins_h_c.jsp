<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.con_ins_h.*, acar.car_mst.*, acar.account.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"5":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	int seq_no = request.getParameter("seq_no")==null?0:AddUtil.parseInt(request.getParameter("seq_no"));
	String ext_id = request.getParameter("ext_id")==null?"":request.getParameter("ext_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	if(m_id.equals("") && !rent_mng_id.equals("")){
		m_id = rent_mng_id;
		l_cd = rent_l_cd;
		c_id = car_mng_id;
	}
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")){ 	user_id = login.getCookieValue(request, "acar_id"); }
	if(br_id.equals("")){ 	br_id = login.getCookieValue(request, "acar_br"); }
	if(auth_rw.equals("")){	 auth_rw = rs_db.getAuthRw(user_id, "05", "01", "05"); }
	
	//�⺻����
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	String brch_id = String.valueOf(fee.get("BRCH_ID"));
	
	//��ü�� ����

	boolean flag = ae_db.calDelay(m_id, l_cd, "6");	

	//���
	IncomingBean ins_h = ae_db.getInsurHScdStat(m_id, l_cd, c_id);
	
	String title = "";
	if(String.valueOf(fee.get("CAR_NO")).indexOf("��") == -1){				title = "������";
	}else{																	title = "������"; }
	
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 7; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-90;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�Ա�ó��&�Ա����&����
	function change_scd(cmd, pay_yn, idx, accid_id, seq_no, ext_tm){
		var fm = document.form1;
		var i_fm = i_in.form1;

		fm.accid_id.value = accid_id;
		fm.cmd.value = cmd;
		fm.pay_yn.value = pay_yn;
		fm.seq_no.value = seq_no;
		fm.ext_tm.value = ext_tm;

		if(idx == 0 && i_fm.tot_tm.value == '1'){
			fm.req_dt.value  = i_fm.req_dt.value;
			fm.req_amt.value = i_fm.req_amt.value;
			fm.pay_amt.value = i_fm.pay_amt.value;
			fm.pay_dt.value  = i_fm.pay_dt.value;		
			fm.pay_gu.value  = i_fm.pay_gu.value;		
		}else{
			fm.req_dt.value = i_fm.req_dt[idx].value;
			fm.req_amt.value = i_fm.req_amt[idx].value;
			fm.pay_amt.value = i_fm.pay_amt[idx].value;
			fm.pay_dt.value  = i_fm.pay_dt[idx].value;		
			fm.pay_gu.value  = i_fm.pay_gu[idx].value;					
		}		

	//	fm.s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pay_amt.value))));
	//	fm.v_amt.value = parseDecimal(toInt(parseDigit(fm.pay_amt.value)) - toInt(parseDigit(fm.s_amt.value)));	
			
		if(cmd == 'p'){
			if(replaceString("-","",fm.pay_dt.value) == " "){				alert('�Ա����ڸ� Ȯ���Ͻʽÿ�');	return;	}
			if(fm.pay_amt.value == ''){	alert('���Աݾ��� Ȯ���Ͻʽÿ�');	return;	}			
			if(!confirm(toInt(idx)+1+'�� <%=title%>�� '+fm.pay_dt.value+'�� '+parseDigit(fm.pay_amt.value)+'������ �Ա�ó���Ͻðڽ��ϱ�?')){
				return;
			}	
		}else if(cmd == 'd'){  //����
			if(  toInt(parseDigit(fm.pay_amt.value))   > 0   ){	alert('���Աݾ��� Ȯ���Ͻʽÿ�');	return;	}	
			if(!confirm(toInt(idx)+1+'�� <%=title%>�� �����Ͻðڽ��ϱ�?')){
				return;
			}
		
		}else if(cmd == 'c'){
			if(!confirm(toInt(idx)+1+'�� <%=title%>�� ('+fm.pay_dt.value+'�� '+parseDigit(fm.pay_amt.value)+'�� �Ա�ó����)�� \n\n �Ա����ó���Ͻðڽ��ϱ�?')){
				return;
			}
			fm.pay_amt.value = '0';
			fm.pay_dt.value = '';
		}else{			
			if(pay_yn == 'N'){
				if(fm.req_amt.value == ''){	alert('û���ݾ��� Ȯ���Ͻʽÿ�');	return;	}
				if(!confirm(toInt(idx)+1+'�� <%=title%>�� û���ݾ��� '+fm.req_amt.value+'������ �����Ͻðڽ��ϱ�?')){
					return;
				}
			}else{
				if(replaceString("-","",fm.pay_dt.value) == " "){				alert('�Ա����ڸ� Ȯ���Ͻʽÿ�');	return;	}
				if(fm.pay_amt.value == ''){	alert('���Աݾ��� Ȯ���Ͻʽÿ�');	return;	}			
				if(!confirm(toInt(idx)+1+'�� <%=title%>�� �Ա����ڸ� '+fm.pay_dt.value+'����,\n\n ���Աݾ��� '+parseDigit(fm.pay_amt.value)+'������ �����Ͻðڽ��ϱ�?')){
					return;
				}
			}
		}
		fm.action='/fms2/con_ins_h/mod_scd_u.jsp';
		fm.target = 'i_no';
//		fm.target = '_blank';		
		fm.submit();		
	}

	//���γ��� ����	
	function view_cont(accid_id, accid_st){
		var fm = document.form1;
		var m_id 	= fm.m_id.value;
		var l_cd 	= fm.l_cd.value;
		var c_id 	= fm.c_id.value;		
		var title 	= fm.title.value;		
		window.open("/fms2/con_ins_m/sub_cont.jsp?gubun=h&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&accid_st="+accid_st+"&title="+title, "CONT", "left=100, top=100, width=700, height=300 scrollbars=yes");
	}
		
	//Ư�̻��� ����	
	function see_etc(){
		var fm = document.form1;
		var m_id 	= fm.m_id.value;
		var l_cd 	= fm.l_cd.value;
		var c_id 	= fm.c_id.value;		
		var client_id = fm.client_id.value;
		var etc 	= fm.etc.value;
		var firm_nm = fm.firm_nm.value;
		var client_nm = fm.client_nm.value;		
		var auth 	= fm.auth.value;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;				
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;			
		window.open("/fms2/con_ins_h/etc_s_p.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&client_id="+client_id+"&etc="+etc+"&firm_nm="+firm_nm+"&client_nm="+client_nm+"&auth="+auth+"&auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc, "ETC", "left=100, top=100, width=500, height=225");
	}
			
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;		
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		var idx 	= fm.idx.value;								
		location = "/fms2/con_ins_h/ins_h_frame_s.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&idx="+idx;
	}	
	
	//���������� �̵�
	function page_move()
	{
		var fm = document.form1;
		var url = "";
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		if(idx == '1') 		url = "/fms2/con_fee/fee_c_mgr.jsp";
		else if(idx == '2') url = "/fms2/con_grt/grt_u.jsp";
		else if(idx == '3') url = "/acar/con_forfeit/forfeit_c.jsp";
		else if(idx == '4') url = "/fms2/con_ins_m/ins_m_c.jsp";
		else if(idx == '5') url = "/fms2/con_ins_h/ins_h_c.jsp";
		else if(idx == '6') url = "/fms2/con_cls/cls_c.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_c.jsp";		
		else if(idx == '8') url = "/acar/con_debt/debt_c.jsp?f_list=pay";		
		else if(idx == '9') url = "/acar/con_ins/ins_u.jsp?f_list=now";		
		else if(idx == '10') url = "/acar/forfeit_mng/forfeit_i_frame.jsp";		
		else if(idx == '11') url = "/acar/commi_mng/commi_u.jsp";										
		else if(idx == '12') url = "/acar/mng_exp/exp_u.jsp";		
		else if(idx == '13') url = "/acar/con_tax/tax_scd_u.jsp";				
		else if(idx == '20') url = "/acar/car_rent/con_reg_frame.jsp?mode=2";				
		else if(idx == '21') url = "/acar/car_service/service_i_frame.jsp?mode=2";				
		else if(idx == '22') url = "/acar/car_accident/car_accid_i_frame.jsp?cmd=u";								
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='r_st' value='1'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='client_id' value='<%=fee.get("CLIENT_ID")%>'>
<input type='hidden' name='etc' value='<%=fee.get("ETC")%>'>
<input type='hidden' name='firm_nm' value='<%=fee.get("FIRM_NM")%>'>
<input type='hidden' name='client_nm' value='<%=fee.get("CLIENT_NM")%>'>
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
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='title' value='<%=title%>'>
<input type='hidden' name='req_amt' value=''>
<input type='hidden' name='pay_amt' value=''>
<input type='hidden' name='pay_gu' value=''>
<input type='hidden' name='req_dt' value=''>
<input type='hidden' name='pay_dt' value=''>
<input type='hidden' name='ext_dt' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='seq_no' value=''>
<input type='hidden' name='pay_yn' value=''>
<input type='hidden' name='s_amt' value=''>
<input type='hidden' name='v_amt' value=''>
<input type='hidden' name='ext_tm' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
	    <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > ������ ���� > <span class=style5>������ ������ ��ȸ �� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td align="right" colspan=2> 

              &nbsp;<a href='javascript:go_to_list()'><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a> 
			  &nbsp;<a href='javascript:history.go(-1);'><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>  
    <tr> 
        <td colspan="2"> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='8%' class='title'>����ȣ</td>
                                <td width='10%'>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                                <td width='8%' class='title'>��ȣ</td>
                                <td width='15%'>&nbsp;<%=fee.get("FIRM_NM")%></td>
                                <td width='8%' class='title'>����</td>
                                <td width='8%'>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                                <td width='8%' class='title'>������ȣ</td>
                                <td width='10%'>&nbsp;<font color="#000099"><b><%=fee.get("CAR_NO")%></b></font></td>
                                <td width='8%' class='title'>����</td>
                                <td width=17%>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm(), 9)%></span></td>
                            </tr>
                            <tr> 
                                <td class='title' width="8%">Ư�̻���</td>
                                <td colspan=9 width=92%><table width=100% border=0 cellspacing=0 cellpadding=3><tr><td>
                                    <%if(fee.get("ETC") != null){%>
                                    <%= fee.get("ETC")%>
                                    <%}%>
                                    </td></tr></table>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td></td>
    </tr>
    <tr>		
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=title%> ���� ������</span></td>
    </tr>
    <tr>
    	<td colspan='2'>
    	  <iframe src="/fms2/con_ins_h/ins_h_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>&ext_id=<%=ext_id%>&brch_id=<%=brch_id%>" name="i_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
    	  </iframe>
    	</td>
    </tr>
    <tr>		
        <td align='right'> 
          <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%><a href='javascript:see_etc()'><img src=/acar/images/center/button_modify_e.gif align=absmiddle border=0></a><%}%> 
        </td>
    	<td width='17'>&nbsp;</td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>		
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=title%> ���</span></td>
    </tr>
    <tr>
	    <td>
	        <table width='100%'>
        		<tr>
        		    <td width='50%'>
        			    <table border="0" cellspacing="0" cellpadding="0" width=100%>
        			        <tr>
            			        <td class=line2></td>
            			    </tr>
        			        <tr>
        				        <td class='line'>
                				    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                                      <tr> 
                                        <td class='title' width='25%'>����</td>
                                        <td class='title' width='25%'>�Ǽ�</td>
                                        <td class='title' width=50%>û���ݾ�</td>
                                    </tr>
                                    <tr> 
                                        <td class='title'>�̼���</td>
                                        <td align='right'><%=ins_h.getTot_su1()%>��&nbsp;&nbsp;</td>
                                      <td align='right'><%=Util.parseDecimal(String.valueOf(ins_h.getTot_amt1()))%>��&nbsp;&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td class='title'>����</td>
                                        <td align='right'><%=ins_h.getTot_su2()%>��&nbsp;&nbsp;</td>
                                      <td align='right'><%=Util.parseDecimal(String.valueOf(ins_h.getTot_amt2()))%>��&nbsp;&nbsp;</td>
                                    </tr>
                                      <tr> 
                                        <td class='title'>�հ�</td>
                                        <td align='right'><%=ins_h.getTot_su1()+ins_h.getTot_su2()%>��&nbsp;&nbsp;</td>
                                        <td align='right'><%=Util.parseDecimal(String.valueOf(ins_h.getTot_amt1()+ins_h.getTot_amt2()))%>��&nbsp;&nbsp;</td>
                                      </tr>
                                    </table>
        				        </td>
        				    </tr>
        			    </table>
        	        <td width='10%'></td>
        			<td width='39%' valign='top'>
        			    <table border="0" cellspacing="0" cellpadding="0" width=100%>
        			        <tr>
        			            <td class=line2></td>
        			        </tr>
        				    <tr>
        				        <td class='line'>
                					<table border="0" cellspacing="1" cellpadding="0" width=100%>
                					    <tr>
                						    <td class='title' width='40%'>��ü�Ǽ� </td>
                						    <td align='right' width=60%><%=ins_h.getTot_su3()%>��&nbsp;&nbsp;</td>
                					    </tr>
                					    <tr>
                					  	    <td class='title'>��ü���</td>
                						    <td align='right'><%=Util.parseDecimal(String.valueOf(ins_h.getTot_amt3()))%>��&nbsp;&nbsp;</td>
                					    </tr>
                					</table>								
        				        </td>
        				    </tr>
        			    </table>
        			</td>
        			<td width=20>&nbsp;</td>
        		 </tr>
	        </table>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
	var fm = document.form1;

	//�ٷΰ���
	var s_fm = parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = fm.client_id.value;			
	s_fm.accid_id.value = fm.accid_id.value;
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
//-->
</script>  
</body>
</html>
