<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.ext.*, acar.cls.*, acar.fee.*, acar.car_mst.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
				//�ϴ������� ����
	function display_c(st){
		var fm = document.form1;	
		fm.st.value = st;
		fm.action = 'rece_c_'+st+'.jsp';	
		fm.target = 'c_foot';
		fm.submit();
	}
		
	function go_to_list()
	{
		var fm = document.form1;	
		fm.action = 'rece_s1_frame.jsp';
		fm.target = 'd_content';
		fm.submit();		
	}	
		
			
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "03");
	
	//��������
	Hashtable fee_base = af_db.getFeebasecls2(m_id, l_cd);
	
	ClsBean cls_info = ac_db.getClsCase(m_id, l_cd);
	
	//��ü�� ���� (�뿩��)
	boolean flag = af_db.calDelayPrint(m_id, l_cd, cls_info.getCls_dt());

	
	//���̿�Ⱓ
	String mon_day = ac_db.getMonDay((String)fee_base.get("RENT_START_DT"), cls_info.getCls_dt());
	String mon = "0";
	String day = "0";
	if(mon_day.length() > 0){
		mon = mon_day.substring(0,mon_day.indexOf('/'));
		day = mon_day.substring(mon_day.indexOf('/')+1);
	}
		
	//ȸ���������� �ʿ�
	//�⺻����
	Hashtable fee = af_db.getFeebase(m_id, l_cd);
	//�Ǻ� �뿩�� ������ ����Ʈ
	Vector fee_scd = af_db.getFeeScd(l_cd, "Y");
	int fee_scd_size = fee_scd.size();
	
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	int  days =  c_db.getDays(  AddUtil.getDate(4), cls_info.getCls_dt());
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 13; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-10;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(height < 50) height = 150;
%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='r_st' value='1'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='cls_tm' value=''>
<input type='hidden' name='pay_amt' value=''>
<input type='hidden' name='cls_s_amt' value=''>
<input type='hidden' name='cls_v_amt' value=''>
<input type='hidden' name='cls_est_dt' value=''>
<input type='hidden' name='pay_dt' value=''>
<input type='hidden' name='ext_dt' value=''>
<input type='hidden' name='st' value=''>
<input type='hidden' name='pay_yn' value=''>
<input type='hidden' name='vat_st' value='<%=cls_info.getVat_st()%>'>
<!--�����뿩��-->
<input type='hidden' name='h_fee_tm' value=''>
<input type='hidden' name='h_tm_st1' value=''>
<input type='hidden' name='h_fee_amt' value=''>
<input type='hidden' name='h_fee_s_amt' value=''>
<input type='hidden' name='h_fee_v_amt' value=''>
<input type='hidden' name='h_rc_amt' value=''>
<input type='hidden' name='h_rc_dt' value=''>
<input type='hidden' name='h_fee_ext_dt' value=''>
<input type='hidden' name='h_ext_gubun' value=''>
<input type='hidden' name='prv_mon_yn' value=''>
<input type='hidden' name='credit_st' value=''>
<input type='hidden' name='page_gubun' value='cls'>
<input type='hidden' name='rent_end_dt' value='<%=cls_info.getCls_dt()%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='ht_rent_seq' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
	    <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ä�ǰ��� > ����ä�ǰ��� > <span class=style5>����ä�� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td align="right"> 
              &nbsp;<a href="javascript:go_to_list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a> 
		
	    </td> 
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                              
                    <td width='12%' class='title' height="91">����ȣ</td>
                    <td height="17%">&nbsp;<%=fee_base.get("RENT_L_CD")%></td>
                    <td width='13%' class='title'>�����</td>
                    <td height="25%">&nbsp;������� : <%=c_db.getNameById((String)fee.get("BUS_ID2"),"USER")%> 
                      / ������� : <%=c_db.getNameById((String)fee.get("MNG_ID"),"USER")%></td>
                    <td width='12%' class='title'>�뿩���</td>
                    <td width='21%'>&nbsp; 
                      <%if(fee_base.get("RENT_WAY").equals("1")){%>
                      �Ϲݽ� 
                      <%}else if(fee_base.get("RENT_WAY").equals("2")){%>
                      ����� 
                      <%}else{%>
                      �⺻�� 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>��ȣ</td>
                    <td>&nbsp;<%=fee_base.get("FIRM_NM")%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=fee_base.get("CLIENT_NM")%></td>
                    <td class='title'>�뿩����</td>
                    <td>&nbsp;<%=mst.getCar_nm()+" "+mst.getCar_name()%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<font color="#000099"><b><%=fee_base.get("CAR_NO")%></b></font></td>
                    <td class='title'>�����</td>
                    <td>&nbsp;<%=fee_base.get("INIT_REG_DT")%></td>
                    <td class='title'>�뿩�Ⱓ</td>
                    <td>&nbsp;<%=fee_base.get("RENT_START_DT")%>&nbsp;~&nbsp;<%=cls_info.getCls_dt()%></td>
                </tr>
                <tr> 
                   <td class='title' height="91">��������</td>
                    <td >&nbsp;<%=cls_info.getCls_st()%> </td>                    
                    <td class='title'>������</td>
                    <td>&nbsp;<%=cls_info.getCls_dt()%>&nbsp;&nbsp; <font color="#000099"> (�������:  <%=days%>��  ) </font></td>
                    <td class='title'>���̿�Ⱓ</td>
                    <td>&nbsp;<%=mon%>����&nbsp;<%=day%>��</td>
              
                </tr>          
                <tr> 
                    <td class='title' style='height:40'>�������� </td>
                    <td colspan="5">
                        <table border="0" cellspacing="0" cellpadding="3" width=100%>
                            <tr>
                                <td><%=cls_info.getCls_cau()%> </td>
                            </tr>
                        </table>
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
    <tr>
        <td class=h></td>
    </tr>		
    
      <tr>
		<td colspan="2" align="center">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		<tr>
        	    <td width='5%'>&nbsp;</td>
        	    <td width='50%' style='text-align=center'>
                        <a href="javascript:display_c('1')">������</a>&nbsp;
             <!--           <a href="javascript:display_c('2')">ȯ��</a>&nbsp;  --���� ���� -->
                        <a href="javascript:display_c('3')">���������</a>&nbsp;
                    <!--    <a href="javascript:display_c('4')">-->���������Ȳ<!-- </a>-->&nbsp;                   
                  <!--       <a href="javascript:display_c('5')"> -->��/��ݰ���<!-- </a> -->&nbsp;                       
		      <a href="javascript:display_c('6')">��Ұ��</a>&nbsp;
		      <a href="javascript:display_c('11')">�Ҽ�</a>&nbsp;
		      <a href="javascript:display_c('7')">ä���߽�</a>&nbsp;
		      <a href="javascript:display_c('8')">��������</a>&nbsp;
		      <a href="javascript:display_c('9')">��ȸ���ڵ���</a>&nbsp;
		      <a href="javascript:display_c('10')">����</a>&nbsp;		 
                  		
        	    </td>
    
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

