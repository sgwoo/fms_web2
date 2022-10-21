<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
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
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//������ȣ�� �߱�����
	CarSecondPlateBean second_plate = a_db.getCarSecondPlate(rent_mng_id, rent_l_cd);
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	from_page = "/fms2/lc_rent/lc_c_c_etc.jsp";
	
	String valus = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//����
	function update(st){
		window.open("/fms2/lc_rent/cng_etc.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=850, height=650");
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
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>Ư�̻���</span><%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id) || nm_db.getWorkAuthUser("����������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%>&nbsp;<a href="javascript:update('etc')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">������ȣ��</td>
                    <td>&nbsp;
                    	<%if (second_plate.getSecond_plate_yn().equals("Y")) {%>
                    	������ȣ�� �߱�
                    	<%} else if (second_plate.getSecond_plate_yn().equals("R")) {%>
                    	������ȣ�� ȸ�� (ȸ���� : <%=AddUtil.ChangeDate2(second_plate.getReturn_dt())%>)
                    	<%} else if (second_plate.getSecond_plate_yn().equals("N")) {%>
                    	������ȣ�� ��ȸ�� (��ȸ�� ���� : <%=second_plate.getEtc()%>)
                    	<%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
    <%if (second_plate.getSecond_plate_yn().equals("Y")) {%>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">������</td>
                    <td>&nbsp;
                    	<%if (second_plate.getWarrant().equals("Y")) {%>�ʼ�<%}%>
                    </td>
                </tr>
                <tr>
                    <td class=title width="13%">����ڵ����</td>
                    <td>&nbsp;
                    	<%if (second_plate.getBus_regist().equals("Y")) {%>�ʿ�<%} else {%>���ʿ�<%}%>
                    </td>
                </tr>
                <tr>
                    <td class=title width="13%">���������</td>
                    <td>&nbsp;
                    	<%if (second_plate.getCar_regist().equals("1")) {%>
                    	�纻
                    	<%} else if (second_plate.getCar_regist().equals("2")) {%>
                    	����(ȸ���ʼ�)
                    	<%}%>
                    </td>
                </tr>
                <tr>
                    <td class=title width="13%">���ε��ε</td>
                    <td>&nbsp;
                    	<%if (second_plate.getCorp_regist().equals("Y")) {%>�ʿ�<%} else {%>���ʿ�<%}%>
                    </td>
                </tr>
                <tr>
                    <td class=title width="13%">�����Ӱ�����</td>
                    <td>&nbsp;
                    	<%if (second_plate.getCorp_cert().equals("Y")) {%>�ʿ�<%} else {%>���ʿ�<%}%>
                    </td>
                </tr>
                <tr>
                    <td class=title width="13%">������</td>
                    <td>&nbsp;
                    	���� ������ : <%=second_plate.getClient_nm()%><br>
                    	&nbsp;
                    	������ ����ó : <%=second_plate.getClient_number()%><br>
                    	&nbsp;
                    	���� ������ : <%=second_plate.getClient_zip()%>&nbsp;<%=second_plate.getClient_addr()%>&nbsp;<%=second_plate.getClient_detail_addr()%>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%}%>
    
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">�ſ���</td>
                    <td>&nbsp;<textarea rows='3' cols='130' name='remark'><%=cont_etc.getDec_etc()%></textarea></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">�뿩����</td>
                    <td>&nbsp;<textarea rows='3' cols='130' name='remark'><%=car.getRemark()%></textarea></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">�������</td>
                    <td>&nbsp;<textarea rows='3' cols='130' name='remark'><%=base.getOthers()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr> 				
    <tr>
        <td class=h></td>
    </tr>
  	<%		for(int i=1; i<=fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i));
				ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(i));%>		   	
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>								
				
                <tr>
                    <td class=title width="13%"><%if(i >1){%><%=i-1%>�� ���� <%}%>�뿩���</td>
                    <td>&nbsp;<textarea rows='3' cols='130' name='remark'><%=fees.getFee_cdt()%></textarea></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%"><%if(i >1){%><%=i-1%>�� ���� <%}%>����ȿ��</td>
                    <td>&nbsp;<textarea rows='3' cols='130' name='remark'><%=fee_etcs.getBc_etc()%></textarea></td>
                </tr>						
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>   	      
    <%if(fee_etcs.getRent_st().equals("1")){%>  
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>								
				
                <tr>
                    <td class=title width="13%"><%if(i >1){%><%=i-1%>�� ���� <%}%>�������İ���<br>(���ü�� ���� �Է�)</td>
                    <td>&nbsp;<textarea rows='3' cols='130' name='remark'><%=fee_etcs.getBus_cau()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr> 	
    <tr>
        <td class=h></td>
    </tr>   		    
    <%}%>    
	<%		}%>			
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">���� ���</td>
                    <td>&nbsp;<textarea rows='3' cols='130' name='cls_etc'><%=cont_etc.getCls_etc()%></textarea></td>
                </tr>							
            </table>
        </td>
    </tr> 	
    <tr>
        <td class=h></td>
    </tr>   

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

	//�ٷΰ���
	var s_fm = parent.parent.top_menu.document.form1;
	var fm 		= document.form1;	
	s_fm.auth_rw.value 	= fm.auth_rw.value;
	s_fm.user_id.value 	= fm.user_id.value;
	s_fm.br_id.value 	= fm.br_id.value;		
	s_fm.m_id.value 	= fm.rent_mng_id.value;
	s_fm.l_cd.value 	= fm.rent_l_cd.value;	
	s_fm.c_id.value 	= fm.car_mng_id.value;
	s_fm.client_id.value = fm.client_id.value;
	s_fm.accid_id.value = "";
	s_fm.serv_id.value 	= "";
	s_fm.seq_no.value 	= "";	

//-->
</script>
</body>
</html>
