<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.con_ins_m.*, acar.car_mst.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
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
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")){ 	user_id = login.getCookieValue(request, "acar_id"); }
	if(br_id.equals("")){	br_id = login.getCookieValue(request, "acar_br"); }
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "21"); }
	
	//�⺻����
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
		
		
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 7; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-120;//��Ȳ ���μ���ŭ ���� ���������� ������
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		var auth_rw 	= fm.auth_rw.value;
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
		var sort_gubun 	= fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		var idx 	= fm.idx.value;						
		location 	= "/fms2/con_s_rent/con_s_rent2_frame.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&idx="+idx;
	}	
	
	//�Ա�ó��&�Ա����&����
	function change_scd(cmd, pay_yn, idx, s_cd, c_id, rent_st, tm){
		var fm = document.form1;
		
		var i_fm = i_in.form1;

		fm.cmd.value 	= cmd;
		fm.pay_yn.value = pay_yn;
		fm.s_cd.value 	= s_cd;
		fm.c_id.value 	= c_id;
		fm.rent_st.value = rent_st;
		fm.tm.value 	= tm;


		if(idx == 0 && i_fm.tot_tm.value == '1'){
			fm.pay_amt.value	= i_fm.pay_amt.value;
			fm.est_dt.value		= i_fm.est_dt.value;	
			fm.pay_dt.value 	= i_fm.pay_dt.value;		
		}else{
			fm.pay_amt.value	= i_fm.pay_amt[idx].value;
			fm.est_dt.value		= i_fm.est_dt[idx].value;	
			fm.pay_dt.value 	= i_fm.pay_dt[idx].value;		
		}	

			
		//�Ա�
		if(cmd == 'p'){
		
			if(replaceString("-","",fm.pay_dt.value) == ""){						alert('�Ա����� Ȯ���Ͻʽÿ�');		return;	}
			if((fm.pay_amt.value == '')||(fm.pay_amt.value == '0')||(fm.pay_amt.value.length > 10)){	alert('���Աݾ��� Ȯ���Ͻʽÿ�');	return;	}
			if(!confirm(toInt(idx)+1+'�� �⺻����������� '+fm.pay_dt.value+'�� '+parseDigit(fm.pay_amt.value)+'������ �Ա�ó���Ͻðڽ��ϱ�?')){
				return;
			}		
		}else{			
			if(pay_yn == 'N'){
				if(fm.est_dt.value == ''){				alert('�Աݿ������� Ȯ���Ͻʽÿ�');	return;	}
				if(!confirm(toInt(idx)+1+'�� �⺻����������� �Աݿ������� '+fm.est_dt.value+'���� �����Ͻðڽ��ϱ�?')){
					return;
				}
			}else{
				if(replaceString("-","",fm.pay_dt.value) == " "){	alert('�Ա����ڸ� Ȯ���Ͻʽÿ�');	return;	}
				if(!confirm(toInt(idx)+1+'�� �⺻����������� �Ա����ڸ� '+fm.pay_dt.value+'���� �����Ͻðڽ��ϱ�?')){
					return;
				}
			}
		}
		fm.action='/fms2/con_s_rent/mod_scd_u.jsp';
		fm.target = 'i_no';
		fm.submit();	

	}
	
	//�Ա�ǥ����
	function reg_payebill(cmd, pay_yn, idx, s_cd, c_id, rent_st, tm){
		var fm = document.form1;

		fm.cmd.value = cmd;
		fm.pay_yn.value = pay_yn;
		fm.s_cd.value = s_cd;
		fm.c_id.value = c_id;
		fm.rent_st.value = rent_st;
		fm.tm.value = tm;
		
		fm.action='/fms2/con_s_rent/payebill_i.jsp';
		fm.target = '_blank';
		fm.submit();		
	}
		
	//���γ��� ����	
	function view_cont(s_cd, c_id){
		var fm = document.form1;
		window.open("/acar/rent_end/rent_settle_u.jsp?mode=view&s_cd="+s_cd+"&c_id="+c_id, "CONT", "left=100, top=100, width=950, height=600 scrollbars=yes");
	}


//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name="depoSlipListForm" method="get">
	<input type="hidden" name="depoSlippubCode" >
	<input type="hidden" name="docType" >
	<input type="hidden" name="userType" >
</form>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='r_st' value='1'>
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
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='pay_yn' value=''>
<input type='hidden' name='rent_st' value=''>
<input type='hidden' name='tm' value=''>
<input type='hidden' name='pay_amt' value=''>
<input type='hidden' name='pay_dt' value=''>
<input type='hidden' name='est_dt' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
	    <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > ������� ���� > <span class=style5>������� ������ ��ȸ �� ����</span></span></td>
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
        <td colspan="2"> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width=8% class='title'>����ȣ</td>
                                <td width=10%>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                                <td width=8% class='title'>��ȣ</td>
                                <td width=15%>&nbsp;<%=fee.get("FIRM_NM")%></td>
                                <td width=8% class='title'>����</td>
                                <td width=8%>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                                <td width=8% class='title'>������ȣ</td>
                                <td width=10%>&nbsp;<font color="#000099"><b><%=fee.get("CAR_NO")%></b></font></td>
                                <td width=8% class='title'>����</td>
                                <td width=17%>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm(), 9)%></span></td>
                            </tr>
                            <tr> 
                                <td class='title' width=8%>Ư�̻���</td>
                                <td width=92% colspan=9>
                                    <table width=100% border=0 cellspacing=0 cellpadding=3>
                                        <tr>
                                            <td>
                                                <%if(fee.get("ETC") != null){%>
                                                <%= fee.get("ETC")%>
                                                <%}%>
                                                </td>
                                        </tR>
                                    </table>
                                </td>
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
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� ���� ������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='3%' class='title' style='height:44'>����</td>
                    <td width='8%' class='title'>��������</td>
                    <td width='10%' class='title'>����</td>
                    <td width='7%' class='title'>�뿩��</td>
                    <td width='6%' class='title'>Ź�۷�</td>
                    <td width='9%' class='title'>û���ݾ�</td>
                    <td width="8%" class='title'>�Աݿ�����</td>
                    <td width='8%' class='title'>�Ա����� </td>
                    <td width='9%' class='title'>���Աݾ� </td>
                    <td width="8%" class='title'>���ݰ�꼭<br>��������</td>			
                    <td width='6%' class='title'>��ü<br>�ϼ� </td>
                    <td width='6%' class='title'>��ü��</td>
                    <td width='6%' class='title'>�Ա�</td>
                    <td width="6%" class='title'>����</td>
                </tr>
	        </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>	
    <tr>
	    <td colspan='2'>
	    <iframe src="/fms2/con_s_rent/con_s_rent2_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&s_cd=<%=s_cd%>" name="i_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
	    </iframe>
	    </td>
    </tr>
</table>

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
/*
	var fm = document.form1;

	//�ٷΰ���
	var s_fm = parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = fm.client_id.vaule;	
	s_fm.accid_id.value = fm.accid_id.value;
	s_fm.serv_id.value = fm.serv_id.value;
	s_fm.seq_no.value = "";
*/	
//-->
</script>  
</body>
</html>
