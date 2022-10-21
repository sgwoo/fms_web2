<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, acar.client.*, tax.*, cust.member.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	//���ϰ��� ������
	
	String mtype 	= request.getParameter("mtype")==null?"":request.getParameter("mtype");
	

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
	int count2 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//cont_view
	Hashtable base 			= a_db.getContViewCase(m_id, l_cd);
	//�ڵ���ü����
	ContCmsBean cms 		= a_db.getCmsMng(m_id, l_cd);
	//�ŷ�ó����
	ClientBean client       = al_db.getClient(String.valueOf(base.get("CLIENT_ID")));
	//�ŷ�ó��������
	ClientSiteBean site     = al_db.getClientSite(String.valueOf(base.get("CLIENT_ID")), String.valueOf(base.get("R_SITE")));
	//�ŷ�ó������̸���
	Vector mgrs 			= al_db.getClientMgrEmailList(String.valueOf(base.get("CLIENT_ID")), l_cd);
	int mgr_size = mgrs.size();
	
	//�뿩���� ī����
	int fee_count	= af_db.getFeeCount(l_cd);
	if(rent_st.equals("")) rent_st = String.valueOf(fee_count);
	//�����뿩������ �뿩Ƚ�� �ִ밪
	int max_fee_tm 	= a_db.getMax_fee_tm(m_id, l_cd, rent_st);
	
	//��FMS�ӽþ��̵� ����
	MemberBean m_bean = m_db.getMemberCase(String.valueOf(base.get("CLIENT_ID")), "", "");
	if(m_bean.getMember_id().equals("")){
		//ȸ������ ���
		MemberBean no_m_bean = m_db.getNoMemberCase(String.valueOf(base.get("CLIENT_ID")), "", "");
		
		int idcnt = m_db.checkMemberIdPwd("amazoncar", no_m_bean.getPwd());
			
		if(idcnt==0){
				count2 = m_db.insertMember(String.valueOf(base.get("CLIENT_ID")), "", "amazoncar", no_m_bean.getPwd(), "");
		}else{
				count2 = m_db.updateMemberUseYN( String.valueOf(base.get("CLIENT_ID")) ); //���� use_yn='N'��'Y'�� ó�� 		
		}			
	
	}
		
	String cls_st = String.valueOf(base.get("CLS_ST"));
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function ImEmail_Reg(){
		var fm = document.form1;
		if(fm.l_cd.value == '')				{	alert('���õ� ����� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(fm.content.options[fm.content.selectedIndex].value == ''){	alert('���������� �����Ͽ� �ֽʽÿ�.'); return; }
		if(fm.content.selectedIndex == '1'){
			if(fm.max_fee_tm.value == '' || fm.max_fee_tm.value == '0')		{	alert('������ �������� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		}
		if(fm.con_agnt_email.value == '')	{	alert('���Ÿ����ּҸ� �Է��Ͻʽÿ�.'); return; }
		
		if(confirm('��� �Ͻðڽ��ϱ�?'))
		{			
			fm.target = "i_no";
			fm.action = "rent_email_reg_a.jsp";
			fm.submit();						
		}	
	}
	
	//�̸�����
	function ImEmail_View(){
		var fm = document.form1;
		if(fm.l_cd.value == '')				{	alert('���õ� ����� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(fm.content.options[fm.content.selectedIndex].value == ''){	alert('���������� �����Ͽ� �ֽʽÿ�.'); return; }		
		if(fm.content.selectedIndex == '1'){
			if(fm.max_fee_tm.value == '' || fm.max_fee_tm.value == '0')		{	alert('������ �������� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		}
		window.open("about:blank", "ScdDocView", "left=150, top=150, width=800, height=650, scrollbars=yes");				
		fm.action = fm.content.options[fm.content.selectedIndex].value;
		fm.target = "ScdDocView";
		fm.submit();
	}
	
	//�޴� ���� ����
	function Email_Set(nm, email){
		var fm = document.form1;
		fm.con_agnt_nm.value 	= nm;
		fm.con_agnt_email.value = email;
	}
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='cls_st' value='<%=base.get("CLS_ST")%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='reg_yn' value='<%=reg_yn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
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
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='max_fee_tm' value='<%=max_fee_tm%>'>
<input type='hidden' name='firm_nm' value='<%=base.get("FIRM_NM")%>'>
<input type='hidden' name='car_no' value='<%=base.get("CAR_NO")%>'>
<input type='hidden' name='client_id' value='<%=base.get("CLIENT_ID")%>'>
<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;��༭���� > <span class=style1><span class=style5>�̸��ϰ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2" class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='11%' class='title'>����ȣ</td>
                    <td width='29%'>&nbsp;<%=base.get("RENT_L_CD")%></td>
                    <td width='11%' class='title'>��ȣ</td>
                    <td width="49%">
                        &nbsp;<%=base.get("FIRM_NM")%>
                        &nbsp;<%=base.get("R_SITE")%></td>
                </tr>
                <tr>
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=base.get("CAR_NO")%></td>
                    <td width="11%" class='title'>����</td>
                    <td>&nbsp;<span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>
                    </span></td>
                </tr>
                <tr>
                    <td class='title'> �뿩��� </td>
                    <td>&nbsp;<%=base.get("RENT_WAY")%></td>
                    <td width="11%" class='title'>CMS</td>
                    <td>
                        &nbsp;<%if(!cms.getCms_bank().equals("")){%>
                        <%=cms.getCms_bank()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%> (�ſ� <%=cms.getCms_day()%>��)
                        <%}else{%>
        			      -
        			    <%}%>
                    </td>
                </tr>
                <tr>
                    <td class='title'>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                    <td width="11%" class='title'>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%></td>
                </tr>
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr> 
<% 	Vector vts = ImEmailDb.getMailHistoryList("4", l_cd);
	int vt_size = vts.size();
	if(vt_size>0){%>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̸��� �߼� ����Ʈ</span></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>		
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>����</td>
                    <td width="25%" class='title'>��������</td>			
                    <td width="25%" class='title'>�߼��Ͻ�</td>
                    <td width="29%" class='title'>�̸����ּ�</td>
                    <td width="8%" class='title'>���ſ���</td>
                    <td width="8%" class='title'>�߼ۻ���</td>
                </tr>
                <%for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vts.elementAt(i);%>		  
                <tr>
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ht.get("MAIL_TYPE")%></td>			
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%></td>
                    <td align='center'><%=ht.get("EMAIL")%></td>
                    <td align='center'><%=ht.get("OCNT_NM")%></td>
                    <td align='center'><%=ht.get("MSGFLAG_NM")%></td>
                </tr>
                <%}%>				  
            </table>
        </td>
    </tr>
<%	}%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ŷ�ó �����</span></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>����</td>
                    <td width="25%" class='title'>����</td>
                    <td width="25%" class='title'>����</td>
                    <td width="45%" class='title'>�̸����ּ�</td>
                </tr>
                <%for(int i = 0 ; i < mgr_size ; i++){
    				Hashtable ht = (Hashtable)mgrs.elementAt(i);%>		  
                <tr>
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ht.get("MGR_ST")%></td>
                    <td align='center'><%=ht.get("MGR_NM")%></td>
                    <td align='center'><a href="javascript:Email_Set('<%=ht.get("MGR_NM")%>','<%=ht.get("MGR_EMAIL")%>');"><%=ht.get("MGR_EMAIL")%></a></td>
                </tr>
                <%}%>
    		    <%if(!client.getCon_agnt_email().equals("")){%>
                <tr>
                    <td align='center'><%=mgr_size+1%></td>
                    <td align='center'>���ݰ�꼭</td>
                    <td align='center'><%=client.getCon_agnt_nm()%></td>
                    <td align='center'><a href="javascript:Email_Set('<%=client.getCon_agnt_nm()%>','<%=client.getCon_agnt_email()%>');"><%=client.getCon_agnt_email()%></a></td>
                </tr>		  	
                <%}%>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>	
    <tr>
        <td colspan="2" class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
   	    
                <tr>
                    <td width='11%' class='title'>��������</td>
                    <td width='89%'>&nbsp;
        			  <select name="content">
<% if (!mtype.equals("cls") ) { %>  
                        <option value="">����</option>                      
						<option value="http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>">�ڵ��� ���� ���� �ȳ���(����)</option> 
                        <!--<option value="http://fms1.amazoncar.co.kr/mailing/rent/scd_fee.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>">���뿩�̿�ȳ���(�뿩�ᳳ��)</option>*/
                        <option value="http://fms1.amazoncar.co.kr/mailing/fms/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>" <%if(gubun.equals("rent_i"))%>selected<%%>>��FMS�̿�ȳ���</option>
                        <option value="http://fms1.amazoncar.co.kr/mailing/car_adm/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>">���������ȳ���</option>
						<option value="http://fms1.amazoncar.co.kr/mailing/ins/sos.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>">����Ÿ�ڵ�������⵿�ȳ���</option>
						<option value="http://fms1.amazoncar.co.kr/mailing/cms/cms_fine.html">�����ӵ���&������ �̳�����ᳳ�� �ȳ���</option>
						<option value="http://fms1.amazoncar.co.kr/mailing/etc/notice_rep.html">���ǵ����Ʈ �ڵ������¾�ü �ȳ���</option>-->
						<option value="http://fms1.amazoncar.co.kr/mailing/cms/bank.html">����纻</option>
						<option value="http://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%//=rent_st%>">���뿩�����پȳ���</option>
						<option value="http://fms1.amazoncar.co.kr/mailing/etc/fine_receipt.html">���·�&�����&������� �������߱ޱ�� �ȳ�</option>
						<!--<option value="http://fms1.amazoncar.co.kr/mailing/etc/2012_play.html">201204 ��������� �ȳ���</option>-->
					<!--	<option value="http://fms1.amazoncar.co.kr/mailing/etc/fine_receipt_t.html">���·�&�����&������� �������߱ޱ�� �ȳ�-FAX��</option> -->
				
<%} %>				
                <% if (base.get("CLS_ST").equals("1") || base.get("CLS_ST").equals("2") ) {   %>   
                        <option value="http://fms1.amazoncar.co.kr/mailing/cls/cls_con_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&cls_st=<%=cls_st%>">�������곻���ȳ���</option>
                <%  } %>  
				<%if(AddUtil.getDate(1).equals("2011") && AddUtil.getDate(2).equals("04")){//201104�� �ѽ��� ������ ����������%>
						<!--<option value="http://fms1.amazoncar.co.kr/mailing/etc/2012_play.html">201204 ��������� �ȳ���</option>-->
				<%}%>
                      </select> 	
                   <!--		<option value="http://fms1.amazoncar.co.kr/mailing/cms/cms_m.html">CMS������׾ȳ���</option>-->   					
                     </td>
                </tr>
            
                <tr>
                    <td width='11%' class='title'>�̸�</td>
                    <td width='89%'>&nbsp;
                    <input type='text' size='15' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>EMAIL</td>
                    <td>&nbsp;
                        <input type='text' size='40' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'></td>
                </tr>
            </table>
         </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
	    <td><a href="javascript:ImEmail_View();"><img src=/acar/images/center/button_see_pre.gif align=absmiddle border=0></a></td>
        <td align="right">
          <a href="javascript:ImEmail_Reg();"><img src=/acar/images/center/button_bh.gif align=absmiddle border=0></a>&nbsp;
		  <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
