<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cls.*, acar.fee.*, acar.car_mst.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//���&����
	function change_scd(cmd, cls_gubun, r_st, tm, tm_st){
		var fm = document.form1;

		fm.cmd.value = cmd;
		fm.cls_gubun.value = cls_gubun;
		fm.r_st.value = r_st;
		fm.tm.value = tm;
		fm.tm_st.value = tm_st;				

		if(cmd == 'c'){//�̼����:bill_yn=Y�� ����
			if(!confirm(tm+tm_st+'ȸ�� '+cls_gubun+'��� ����Ͻðڽ��ϱ�?')){
				return;
			}
		}else{		
			if(!confirm(tm+tm_st+'ȸ�� '+cls_gubun+'�����Ͻðڽ��ϱ�?')){
				return;
			}
		}
		fm.action='/acar/stat_credit/mod_scd_u.jsp';
		fm.target = 'i_no';
		fm.submit();		
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
		location = "/acar/stat_credit/credit_frame_s.jsp?auth_rw="+auth_rw+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
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
		else if(idx == '5') url = "/acar/con_ins_h/ins_h_c.jsp";
		else if(idx == '6') url = "/fms2/con_cls/cls_c.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_c.jsp";		
		else if(idx == '8') url = "/acar/stat_credit/credit_c.jsp";				
		fm.action = url;		
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
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//��������
	Hashtable fee_base = ac_db.getFeebasecls2(m_id, l_cd);
	ClsBean cls_info = ac_db.getClsCase(m_id, l_cd);
	
	//���
	IncomingBean cls = ac_db.getClsScdCaseStat(m_id, l_cd);
	
	//���̿�Ⱓ
	String mon_day = ac_db.getMonDay((String)fee_base.get("RENT_START_DT"), cls_info.getCls_dt());
	String mon = "";
	String day = "";
	
	if(mon_day.length() > 0 && mon_day.indexOf('/') != -1){
		mon = mon_day.substring(0,mon_day.indexOf('/'));
		day = mon_day.substring(mon_day.indexOf('/')+1);
	}
	if(mon.equals("")) mon="0";
	if(day.equals("")) day="0";
	
	//��/������ �̸�
	String h_title = "������";
	if(!String.valueOf(fee_base.get("CAR_NO")).equals("")){
		if(String.valueOf(fee_base.get("CAR_NO")).substring(4,5).equals("��")) 	h_title = "������";
		else																	h_title = "������";
	}
	
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 7; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-90;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='r_st' value='1'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<!--<input type='hidden' name='gubun1' value='<%=gubun1%>'>-->
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='cls_gubun' value=''>
<input type='hidden' name='tm' value=''>
<input type='hidden' name='tm_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ���ä�� ���� > <span class=style5>���ä�� ��ȸ</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td align='right'>
        	  <select name="gubun1">
          		<option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>�뿩��</option>
		        <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>������</option>
        		<option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>���·�</option>
		        <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>��å��</option>
        		<option value="5" <%if(gubun1.equals("5")){%>selected<%}%>><%=h_title%></option>
		        <option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>���������</option>
        		<option value="7" <%if(gubun1.equals("7")){%>selected<%}%>>�̼�������</option>
        		<option value="8" <%if(gubun1.equals("8")){%>selected<%}%>>���ä��</option>				
        	  </select>
        	  <a href="javascript:page_move();"><img src=/acar/images/center/button_move.gif border=0 align=absmiddle></a>&nbsp;
              <a href='javascript:go_to_list()'><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a>	
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp;<%=cls_info.getCls_st()%> </td>
                    <td class='title'>����ȣ</td>
                    <td colspan="3">&nbsp;<%=fee_base.get("RENT_L_CD")%></td>
                </tr>
                <tr> 
                    <td width=12% class='title'>��ȣ</td>
                    <td width=19%>&nbsp;<%=fee_base.get("FIRM_NM")%></td>
                    <td width=14% class='title'>����</td>
                    <td width=19%>&nbsp;<%=fee_base.get("CLIENT_NM")%></td>
                    <td width=12% class='title'>�뿩����</td>
                    <td width=24%>&nbsp;<%=mst.getCar_nm()+" "+mst.getCar_name()%></td>
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
                    <td class='title'>�Ѵ뿩�Ⱓ</td>
                    <td>&nbsp;<%=fee_base.get("TOT_CON_MON")%>����</td>
                    <td class='title'>���̿�Ⱓ</td>
                    <td>&nbsp;<%=mon%>����&nbsp;<%=day%>��</td>
                    <td class='title'>�뿩���</td>
                    <td>&nbsp; 
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
                    <td class='title'>���뿩��</td>
                    <td>&nbsp; 
                      <%if(fee_base.get("RENT_ST").equals("1")){%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("FEE_AMT")))%> 
                      <%}else{%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_FEE_AMT")))%> 
                      <%}%>
                      ��&nbsp;</td>
                    <td class='title'>�����ݾ�</td>
                    <td>&nbsp; 
                      <%if(fee_base.get("RENT_ST").equals("1")){%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT")))%> 
                      <%}else{%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_PP_AMT"))+AddUtil.parseInt((String)fee_base.get("EX_IFEE_AMT")))%> 
                      <%}%>
                      ��&nbsp;</td>
                    <td class='title'>���ô뿩��</td>
                    <td>&nbsp; 
                      <%if(fee_base.get("RENT_ST").equals("1")){%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT")))%> 
                      <%}else{%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_PP_AMT"))+AddUtil.parseInt((String)fee_base.get("EX_IFEE_AMT")))%> 
                      <%}%>
                      ��&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>������&nbsp;���Թ��</td>
                    <td>&nbsp; 
                      <% if(cls_info.getPp_st().equals("1")){%>
                      3����ġ�뿩�ἱ���� 
                      <%}else{%>
                      �������������� 
                      <%}%>
                    </td>
                    <td class='title'>���ݰ�꼭 ��������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(cls_info.getExt_dt())%></td>
                    <td class='title'>�ΰ������Կ���</td>
                    <td>&nbsp; 
                      <% if(cls_info.getVat_st().equals("1")){%>
                      ���� 
                      <%}else{%>
                      ������ 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class='title' style='height:44'>�������� </td>
                    <td colspan="5">
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                    <%=cls_info.getCls_cau()%> </td>
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
        <td align='left' colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ä�� ������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10% class='title'>����</td>
                    <td width=15% class='title'>ä�Ǳ���</td>
                    <td width=15% class='title'>��ձ���</td>
                    <td width=15% class='title'>ȸ��</td>
                    <td width=21% class='title'>�ݾ�</td>
                    <td width=12% class='title'>&nbsp;&nbsp;���&nbsp;&nbsp;</td>
                    <td width=12% class='title'>&nbsp;&nbsp;����&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
        <td width='17' align='left'>&nbsp;</td>	  
    </tr>	
    <tr> 
        <td colspan="2"><iframe src="/acar/stat_credit/credit_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&client_id=<%=client_id%>&brch_id=<%=fee_base.get("BRCH_ID")%>" name="i_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0> 
        </iframe> </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
