<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.client.*, acar.car_register.*, acar.car_mst.*, acar.alink.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" scope="page" class="acar.car_register.CarRegBean"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	String link_table 	= request.getParameter("link_table")==null?"":request.getParameter("link_table");
	String link_type 	= request.getParameter("link_type")==null?"":request.getParameter("link_type");
	String link_rent_st 	= request.getParameter("link_rent_st")==null?"":request.getParameter("link_rent_st");
	String link_im_seq 	= request.getParameter("link_im_seq")==null?"":request.getParameter("link_im_seq");

	if(link_table.equals("rm_rent_link_m")) link_table = "rm_rent_link";
	

	
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();


	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}	
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));	
	
	//�������
	CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "�������");
	
	//���°�-����������
	CarMgrBean suc_mgr = new CarMgrBean();
	
	if(link_type.equals("2")){	
		suc_mgr = a_db.getCarMgr(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd(), "�������");	
	}
	
	//��������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");	
	
	//������ ��༭�� �ִ��� Ȯ���Ѵ�.
	Vector vt = ln_db.getALinkHisList(link_table, link_type, rent_l_cd, link_rent_st, link_im_seq); 
	int vt_size = vt.size();

	Vector vt3 = ln_db.getALinkHisStatList(link_table, link_type, rent_l_cd, link_rent_st, link_im_seq); 
	int vt_size3 = vt3.size();

	
	Vector vt2 = new Vector();
	int vt_size2 = 0;
		
	Vector vt4 = new Vector();
	int vt_size4 = 0;

	if(link_table.equals("rm_rent_link")){
		vt2 = ln_db.getALinkHisListM("rm_rent_link_m", link_type, rent_l_cd, link_rent_st, link_im_seq); 
		vt_size2 = vt2.size();	
		
		vt4 = ln_db.getALinkHisStatListM("rm_rent_link_m", link_type, rent_l_cd, link_rent_st, link_im_seq); 
		vt_size4 = vt4.size();
		
	}

	
	String wait_yn = "N";
	
	
	int wait_cnt = 0;

	int alink_y_count = ln_db.getALinkCntY(link_table, rent_l_cd, link_rent_st);
	
	
	String edoc_link_yn 		= e_db.getEstiSikVarCase("1", "", "edoc_link_yn");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�̸����ּ� ����
	function isEmail(str) {
		// regular expression? ���� ���� ����
		var supported = 0;
		if (window.RegExp) {
			var tempStr = "a";
			var tempReg = new RegExp(tempStr);
			if (tempReg.test(tempStr)) supported = 1;
		}
		if (!supported) return (str.indexOf(".") > 2) && (str.indexOf("@") > 0);
		var r1 = new RegExp("(@.*@)|(\\.\\.)|(@\\.)|(^\\.)");
		var r2 = new RegExp("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$");
		return (!r1.test(str) && r2.test(str));
	}
	
	//���Ÿ����ּ� ����
	function mail_addr_set(){
		var fm = document.form1;
		var i_mail_addr = fm.s_mail_addr.options[fm.s_mail_addr.selectedIndex].value;
		
		if(i_mail_addr != ''){		
			var i_mail_addr_split 	= i_mail_addr.split("||");
			fm.mgr_nm.value 	= i_mail_addr_split[0];
			fm.mgr_email.value 	= i_mail_addr_split[1];
			fm.mgr_m_tel.value 	= i_mail_addr_split[2];
		}else{
			fm.mgr_nm.value 	= '';
			fm.mgr_email.value 	= '';
			fm.mgr_m_tel.value 	= '';
		}
	}	
	
	<%if(link_type.equals("2")){	%>
	//���������� ���Ÿ����ּ� ����
	function suc_mail_addr_set(){
		var fm = document.form1;
		var i_mail_addr = fm.suc_s_mail_addr.options[fm.suc_s_mail_addr.selectedIndex].value;
		
		if(i_mail_addr != ''){		
			var i_mail_addr_split 	= i_mail_addr.split("||");
			fm.suc_mgr_nm.value 	= i_mail_addr_split[0];
			fm.suc_mgr_email.value 	= i_mail_addr_split[1];
			fm.suc_mgr_m_tel.value 	= i_mail_addr_split[2];
		}else{
			fm.suc_mgr_nm.value 	= '';
			fm.suc_mgr_email.value 	= '';
			fm.suc_mgr_m_tel.value 	= '';
		}
	}
	<%}%>		
		
	function link_send(){		
		var fm = document.form1;
		
		var addr = fm.mgr_email.value;
		
		<%if(edoc_link_yn.equals("N")){%>
			alert('�����۾����� ���� �ߴ��մϴ�.');
			return;
		<%}%>
		
		<%if(link_table.equals("lc_rent_link") && client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1") && !cont_etc.getClient_share_st().equals("1")){%>
			alert('����༭ �����϶��� ��ǥ�� ���뺸�� ��� ��ǥ�� ���������� �ؾ� �մϴ�. ');	
			return;
		<%}%>	
		
		<%if(link_table.equals("lc_rent_link") && client.getClient_st().equals("2") && client.getM_tel().equals("")){%>
			alert('����༭ �����϶��� �޴��� ��ȣ�� �ԷµǾ�� �մϴ�. ���������� �Է��Ͻʽÿ�.');	
			return;
		<%}%>			
		
		<%if(link_table.equals("rm_rent_link")){%>
		<%	if(fee_rm.getCms_type().equals("")){%>
		if(fm.cms_type[0].checked == false && fm.cms_type[1].checked == false){		
			alert('2ȸ�� û������� �����Ͻʽÿ�.'); return;
		}
		<%	}%>
		<%}%>
		
		
						
		if(fm.rent_l_cd.value == '') 	{ alert('��༭�� ���õ��� �ʾҽ��ϴ�. ���Ϲ߼��� �ȵ˴ϴ�.'); 	return; }
		
		if(fm.email_chk.checked==false){ 
			if(isEmail(addr)==false)	{ alert("�ùٸ� �̸����ּҸ� �Է����ּ���"); 			return; }
		}
		if(addr=="" || addr=="@")	{ alert("�����ּҸ� �Է����ּ���!"); 				return; }
		if(addr.indexOf("@")<0)		{ alert("�����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); 			return; }
		if(addr.indexOf(".")<0)		{ alert("�����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); 			return; }
		if(get_length(addr) < 5)	{ alert("�����ּҰ� ��Ȯ���� �ʽ��ϴ�!"); 			return; }
		
		//���������� �̸��������ʼ��Է�(20190219)
		<%if(cont_etc.getClient_share_st().equals("1")){%>
			<%if(client.getRepre_email().equals("")){%>
				alert("������������ �̸��� ������ �Է��ϼ���. ���������� �Է��Ͻʽÿ�.");	return;
			<%}%>	
		<%}%>
		
		fm.action='reg_edoc_link_send.jsp';		
		fm.target='_self';
		fm.submit();
	}
	
	function link_resend(link_com, doc_code){		
		var fm = document.form1;

		<%if(edoc_link_yn.equals("N")){%>
			alert('�����۾����� ���� �ߴ��մϴ�.');
			return;
		<%}%>

		<%if(link_table.equals("lc_rent_link") && client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1") && !cont_etc.getClient_share_st().equals("1")){%>
			alert('����༭ �����϶��� ��ǥ�� ���뺸�� ��� ��ǥ�� ���������� �ؾ� �մϴ�. ');	
			return;
		<%}%>
		
		//���������� �̸��������ʼ��Է�(20190219)
		<%if(cont_etc.getClient_share_st().equals("1")){%>
			<%if(client.getRepre_email().equals("")){%>
				alert("������������ �̸��� ������ �Է��ϼ���. ���������� �Է��Ͻʽÿ�.");	return;
			<%}%>	
		<%}%>
		
		fm.doc_code.value = doc_code;	
		
		if(link_com == '2')		fm.link_table.value = fm.link_table.value+'_m';		
		
		fm.action='reg_edoc_link_resend.jsp';					
		fm.target='_self';		
		fm.submit();
	}	

	function link_delete(link_com, doc_code){		
		var fm = document.form1;
		
		<%if(edoc_link_yn.equals("N")){%>
			alert('�����۾����� ���� �ߴ��մϴ�.');
			return;
		<%}%>
		
		fm.doc_code.value = doc_code;			
		
		if(link_com == '2')		fm.link_table.value = fm.link_table.value+'_m';		
		
		fm.action='reg_edoc_link_delete.jsp';		
		fm.target='_self';
		fm.submit();
	}	

	function link_delete_admin(link_com, doc_code){		
		var fm = document.form1;
		
		<%if(edoc_link_yn.equals("N")){%>
			alert('�����۾����� ���� �ߴ��մϴ�.');
			return;
		<%}%>
		
		fm.doc_code.value = doc_code;			
		
		if(link_com == '2')		fm.link_table.value = fm.link_table.value+'_m';		
		
		fm.action='reg_edoc_link_delete_admin.jsp';		
		fm.target='_self';
		fm.submit();
	}	
	
	var popObj = null;


	function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
	}	
	
//-->
</script>

<%-- jjlim add papyless --%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

<Script language="JavaScript">

	function webMethodCall(webServiceUrl,methodName,arg,returnFunction) {
		var request = createRequestObject();

		var args = arg.split("&");
		var sendXML = "";
		
		sendXML += "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
		sendXML += "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">";
		sendXML += "<soap:Body>";
		sendXML += "<"+methodName+" xmlns=\"http://tempuri.org/\">";

		for (var i = 0; i < args.length; i++) {
			var keyAndValue = args[i].split("=");

			if (keyAndValue.length == 2) {
				var key = keyAndValue[0];
				var value = keyAndValue[1];

				value= value.replace(/>/g,"==");
				value= value.replace(/</g,"||");

				sendXML += "<" + key + ">" + value + "</" + key + ">";
			}
		}

		sendXML += "</"+methodName+">";
		sendXML += "</soap:Body>";
		sendXML += "</soap:Envelope>";


        // jjlim add papyless
        var param = {
            url: "/AmazonCar.asmx",
            method: methodName,
            body: sendXML
        };
        $.ajax({
            contentType: 'application/json',
            dataType: 'json',
            data: JSON.stringify(param),
            url: 'reg_edoc_link_proxy.jsp',
            type: 'POST',
            success: function(data) {
                returnFunction(data['result']);
            },
            error: function(xhr, status, error) {
                alert(error);
            }
        });
//        request.open("POST", webServiceUrl, false);
//
//		request.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
//		request.setRequestHeader("SOAPAction", "http://tempuri.org/" + methodName);
//		request.setRequestHeader("Content-Length", sendXML.length);
//
//		request.onreadystatechange = function RequestCallBack() {
//			var state = { "UNINITIALIZED": 0, "LOADING": 1, "LOADED": 2, "INTERAVTIVE": 3, "COMPLETED": 4 };
//			switch (request.readyState) {
//				case state.UNINITIALIZED:
//				break;
//			case state.LOADING:
//				break;
//			case state.LOADED:
//				break;
//			case state.INTERAVTIVE:
//				break;
//			case state.COMPLETED:
//				returnFunction(request.responseText);
//				break;
//			}
//		};
//		request.send(sendXML);

    }

	function createRequestObject() {
		if (window.XMLHttpRequest) {
			return xmlhttprequest = new XMLHttpRequest();
		}
		else if (window.ActiveXObject) {
			return xmlhttprequest = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}


	function CallInsertTypeE(regno, rent_l_cd, rent_st, im_seq)
	{
		var sendXML ="";

		sendXML += "<root> ";
		sendXML += "<REGNO>"+regno+"</REGNO> ";
		sendXML += "<rent_l_cd>"+rent_l_cd+"</rent_l_cd> ";
		sendXML += "<rent_st>"+rent_st+"</rent_st> ";
		sendXML += "<im_seq>"+im_seq+"</im_seq> ";
		sendXML += "</root>";
		
		<%if(edoc_link_yn.equals("N")){%>
			alert('�����۾����� ���� �ߴ��մϴ�.');
			return;
		<%}%>		

		webMethodCall("http://www.papyless.co.kr/AmazonCar.asmx", "GetStatus", "XmlString=" + sendXML , RtnService);
	}

	function RtnService(returnvalue)
	{
	
		
		var stemp="";
		stemp = returnvalue.substring(returnvalue.indexOf("<GetStatusResult>"),returnvalue.length);
		stemp = stemp.substring(17,stemp.indexOf("</GetStatusResult>"));
		
		//alert(stemp);
		//return(stemp);
		document.write(stemp);
		
	}

</Script>

</head>

<body>
<!-- <center> -->
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 		value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>      
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="now_stat" 		value="<%=now_stat%>">   
  <input type='hidden' name="link_table" 	value="<%=link_table%>">  
  <input type='hidden' name="link_type" 	value="<%=link_type%>">  
  <input type='hidden' name="link_rent_st" 	value="<%=link_rent_st%>">  
  <input type='hidden' name="link_im_seq" 	value="<%=link_im_seq%>">  
  <input type='hidden' name="doc_code" 	        value="">  
  

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>���ڹ��� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td style="font-size: 20px; font-weight: bold; padding-bottom: 10px; padding-top: 10px;">������ ���ڰ�༭ ����</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>����ȣ</td>
                    <td width='40%'>&nbsp;<%=rent_l_cd%></td>
                    <td class='title' width='10%'>��ȣ</td>
                    <td width='40%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=cm_bean.getCar_comp_nm()%> <%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>��������</td>
                    <td width='90%'>&nbsp;
                        <%if(link_table.equals("lc_rent_link")){%>
                        ���뿩 ��༭
                            <%if(link_type.equals("2")){%>
                            (���°�)
                            <%}else if(link_type.equals("3")){%>
                            (����)
                            <%}%>
                        <%}else if(link_table.equals("rm_rent_link")){%>
                        ����Ʈ ��༭
                        <%}else if(link_table.equals("cms_link")){%>
                        CMS �����ü ��û��
                        <%}%>                    
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <%if(vt_size >0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ڹ��� ���۳���</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>����</td>
                    <td class="title" width='20%'>��������</td>
                    <td class="title" width='15%'>������</td>                    
                    <td class="title" width='25%'>�����ڸ���</td>
                    <td class="title" width='15%'>�������޴���</td>
                    <td class="title" width='20%'>��������</td>                                        
                </tr>                
                <% 	for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);  					
				
				wait_yn = "Y";
				
				if((i+1)==vt_size && ( !String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�") && !String.valueOf(ht.get("DOC_STAT")).equals("���ΰ���") && !String.valueOf(ht.get("DOC_STAT")).equals("�Ⱓ����") && !String.valueOf(ht.get("DOC_STAT")).equals("����ı�") )){
				    	wait_yn = "Y";
				}else{
					wait_yn = "N";
				}
				
				if((i+1)==vt_size && String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�")){
				    	wait_yn = "Y";
				} 
				
				if(String.valueOf(ht.get("DOC_YN")).equals("D")){
					wait_yn = "N"; //�߰������Ѵ�.
				}
									
				if(String.valueOf(ht.get("DOC_YN")).equals("Y") || String.valueOf(ht.get("DOC_YN")).equals("U")){
					wait_yn = "Y"; //���� �ִ°� ����
					wait_cnt++;
				}
				
 		%>                

                <tr>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>><%= i+1 %></td>
                    <td align="center"><%=ht.get("REG_DT")%></td>					
                    <td align="center"><input type='text' size='15' name='n_mgr_nm' value='<%=ht.get("CLIENT_USER_NM")%>' maxlength='20' class='text'></td>
                    <td align="center"><input type='text' size='25' name='n_mgr_email' value='<%=ht.get("CLIENT_USER_EMAIL")%>' maxlength='50' class='text'></td>
                    <td align="center"><input type='text' size='15' name='n_mgr_m_tel' value='<%=ht.get("CLIENT_USER_TEL")%>' maxlength='20' class='text'></td>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>>
                                            
                        <%if(String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�") && !String.valueOf(ht.get("DOC_YN")).equals("D")){%>
                        
                        		<%=ht.get("DOC_STAT")%>
                        
                        <%}else{%>
                        
                            <%if(String.valueOf(ht.get("DOC_YN")).equals("Y")){%>����
                            <%}else if(String.valueOf(ht.get("DOC_YN")).equals("U")){%>����
                            <%}else if(String.valueOf(ht.get("DOC_YN")).equals("D")){%>����
                            <%}%>
                            
                        <%}%>
                        
                        <%-- <%if(!String.valueOf(ht.get("DOC_YN")).equals("D")){%> --%>	<!-- ��������(2018.05.03) -->
                        
                        	<%if(!String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�") && !String.valueOf(ht.get("DOC_STAT")).equals("����") && !String.valueOf(ht.get("DOC_STAT")).equals("���ΰ���") && !String.valueOf(ht.get("DOC_STAT")).equals("�Ⱓ����") && !String.valueOf(ht.get("DOC_STAT")).equals("����ı�")){%>
                            &nbsp;
 		                        <a href="javascript:link_resend('1', '<%=ht.get("DOC_CODE")%>')" onMouseOver="window.status=''; return true">[������]</a>&nbsp;
                          <%}%>
                        	<%if(!String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�") && !String.valueOf(ht.get("DOC_STAT")).equals("����ı�") && !String.valueOf(ht.get("DOC_STAT")).equals("����")){%>
                            &nbsp;
		            						<a href="javascript:link_delete('1', '<%=ht.get("DOC_CODE")%>')" onMouseOver="window.status=''; return true">[��  ��]</a>
                        	<%}%>
                        
                        
                        	<%if(nm_db.getWorkAuthUser("������",user_id) && String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�")){%>
                            &nbsp;
		                        <a href="javascript:link_delete_admin('1', '<%=ht.get("DOC_CODE")%>')" onMouseOver="window.status=''; return true">[�Ϸ�� ���]</a>                        
                        	<%}%>
                                                
                        <%-- <%}%> --%>
		        
                    </td>
                </tr>
                <%		if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>
                <tr>                                        
                    <td align="center">����������</td>
                    <td align="center"><input type='text' size='15' name='n_suc_mgr_nm' value='<%=ht.get("RENT_SUC_CLIENT_USER_NM")%>' maxlength='20' class='text'></td>
                    <td align="center"><input type='text' size='25' name='n_suc_mgr_email' value='<%=ht.get("RENT_SUC_CLIENT_USER_EMAIL")%>' maxlength='50' class='text'></td>
                    <td align="center"><input type='text' size='15' name='n_suc_mgr_m_tel' value='<%=ht.get("RENT_SUC_CLIENT_USER_TEL")%>' maxlength='20' class='text'></td>                    
                </tr>
                
                <%		}%>
                <% 	}%>
            </table>
        </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ڹ��� ���۳��� ���� �̷� </span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>����</td>
                    <td class="title" width='20%'>�����Ͻ�</td>
                    <td class="title" width='30%'>����</td>                    
                    <td class="title" width='45%'>���</td>
                </tr>        
                <% 	for (int i = 0 ; i < vt_size3 ; i++){
				Hashtable ht = (Hashtable)vt3.elementAt(i);  
				
				if((i+1)==vt_size3 && String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�")){
				    	wait_yn = "Y";
				    	wait_cnt = 0;
				} 					
									
 		%>                               
                <tr>
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>					
                    <td align="center"><%=ht.get("INDEX_STATUS")%></td>
                    <td align="center"><%=ht.get("ETC")%></td>
                </tr>
                <%	}	%>
            </table>
        </td>
    </tr>    
    <%}%>
    
    <%if(vt_size2 >0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� ���ڹ��� ���۳���</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>����</td>
                    <td class="title" width='15%'>��������</td>
                    <td class="title" width='15%'>������</td>                    
                    <td class="title" width='20%'>�����ڸ���</td>
                    <td class="title" width='15%'>�������޴���</td>
                    <td class="title" width='5%'>����</td>
                    <td class="title" width='10%'>����</td>
                    <td class="title" width='15%'>-</td>
                </tr>                
                <% 	for (int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);  					
				
				wait_yn = "Y";
				
				if((i+1)==vt_size2 && ( !String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�") )){
				    	wait_yn = "Y";
				}if((i+1)==vt_size2 && ( !String.valueOf(ht.get("DOC_YN")).equals("D") )){
				    	wait_yn = "Y";
				}if((i+1)==vt_size2 && ( String.valueOf(ht.get("DOC_YN_NM")).equals("���") )){
				    	wait_yn = "Y";
				}else{
					wait_yn = "N"; //�߰������Ѵ�.
				}
				
				if(String.valueOf(ht.get("DOC_YN")).equals("D")){
					wait_yn = "N"; //�߰������Ѵ�.
				}
				
				
				
 		%>                

                <tr>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>><%= i+1 %></td>
                    <td align="center"><%=ht.get("REG_DT")%></td>					
                    <td align="center"><%=ht.get("CLIENT_USER_NM")%></td>
                    <td align="center"><%=ht.get("CLIENT_USER_EMAIL")%></td>
                    <td align="center"><%=ht.get("CLIENT_USER_TEL")%></td>
                    <td align="center"><%=ht.get("DOC_YN_NM")%></td>
                    <td align="center"><%=ht.get("DOC_STAT")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>>                                            
                        <%if(!String.valueOf(ht.get("DOC_YN")).equals("D")){%>
                            &nbsp;
 		            <!--<a href="javascript:link_resend('2', '<%=ht.get("DOC_CODE")%>')" onMouseOver="window.status=''; return true">[������]</a>&nbsp;-->
		            <a href="javascript:link_delete('2', '<%=ht.get("DOC_CODE")%>')" onMouseOver="window.status=''; return true">[��  ��]</a>
                        <%}else{%>
                            -
                        <%}%>
                    </td>
                </tr>
                <%		if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>
                <tr>                                        
                    <td align="center">����������</td>
                    <td align="center"><%=ht.get("RENT_SUC_CLIENT_USER_NM")%></td>
                    <td align="center"><%=ht.get("RENT_SUC_CLIENT_USER_EMAIL")%></td>
                    <td align="center"><%=ht.get("RENT_SUC_CLIENT_USER_TEL")%></td>                    
                </tr>
                
                <%		}%>
                <% 	}%>
            </table>
        </td>
    </tr> 
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� ���ڹ��� ���۳��� ���� �̷� </span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>����</td>
                    <td class="title" width='20%'>����</td>
                    <td class="title" width='20%'>�����Ͻ�</td>
                    <td class="title" width='20%'>����</td>                    
                    <td class="title" width='35%'>���</td>
                </tr>        
                <% 	for (int i = 0 ; i < vt_size4 ; i++){
				Hashtable ht = (Hashtable)vt4.elementAt(i);  
				
				if((i+1)==vt_size4 && String.valueOf(ht.get("DOC_STAT")).equals("�Ϸ�")){
				    	wait_yn = "Y";
				} 														
				if((i+1)==vt_size4 && String.valueOf(ht.get("TMSG_NM")).equals("����Ʈ��༭ ����")){
				    	wait_yn = "N";
				} 														

 		%>                               
                <tr>
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%=ht.get("TMSG_NM")%></td>					
                    <td align="center"><%=ht.get("REG_DATE")%></td>					
                    <td align="center"><%=ht.get("DOC_STAT")%></td>
                    <td align="center">
                        <%if(String.valueOf(ht.get("TMSG_KNCD")).equals("AC611") || String.valueOf(ht.get("TMSG_KNCD")).equals("AC613")){%>
                            <a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME")%>','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><%=ht.get("FILE_NAME")%></a>
                        <%}%>
                    </td>
                </tr>
                <%	}	%>
            </table>
        </td>
    </tr>        
    <%}%>  
    
     
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>    
    <!--������ �ٷ� ���� ����-->
    <%if(!base.getUse_yn().equals("N") && wait_yn.equals("N") && wait_cnt == 0 && alink_y_count==0){%>
    <%    if(link_type.equals("2")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ������ : <%=client.getFirm_nm()%></span></td>
	</tr>       
    <%    }else{%>    	    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
	</tr>   
    <%    }%>	 
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <%if(link_table.equals("rm_rent_link")){%>
	          <tr>
	            <td width='10%' class='title'>���۱���</td>
	            <td width='90%'>&nbsp;
      			<!--<input type='radio' name="link_com" value='2' checked>-->
                                ����� <!--- ���������� ���ޱ�� ���� ����-->
      				<input type='hidden' name='link_com' 		value='2'>   
      				<!--
	                <input type='radio' name="link_com" value='1' >
     				�¶��� - ���ͳ� ���������� ����-->
	            </td>
	          </tr>           
	          <tr>
	            <td width='10%' class='title'>2ȸ��û�����</td>
	            <td width='90%'>&nbsp;
	            <!--	
      				CMS 
      				<input type='hidden' name='cms_type' 		value='cms'>
      				-->
      				<%if(fee_rm.getCms_type().equals("card")){%>
      				�ſ�ī��
      				<input type='hidden' name='cms_type' 		value='card'>
      				<%}else if(fee_rm.getCms_type().equals("cms")){%>
      				CMS
      				<input type='hidden' name='cms_type' 		value='cms'>
      				<%}else{%>
              <input type='radio' name="cms_type" value='card' checked>
     				  �ſ�ī��
      			  <input type='radio' name="cms_type" value='cms'>
      			  CMS 
      			  <%}%>
	            </td>
	          </tr>
                  <%}%>
	          <tr>
	            <td class='title'>������</td>
	            <td>&nbsp;
                        <select name="s_mail_addr"  onChange='javascript:mail_addr_set();'>
			    <option value="">����</option>
        		    <%if(!client.getCon_agnt_email().equals("")){%>
        		    <option value="<%=client.getCon_agnt_nm()%>||<%=client.getCon_agnt_email()%>||<%=client.getCon_agnt_m_tel()%>">[���ݰ�꼭] <%=client.getCon_agnt_email()%> <%=client.getCon_agnt_nm()%></option>
        		    <%}%>
        		    <%if(!site.getAgnt_email().equals("")){%>
        		    <option value="<%=site.getAgnt_nm()%>||<%=site.getAgnt_email()%>||<%=site.getAgnt_m_tel()%>">[�������ݰ�꼭] <%=site.getAgnt_email()%> <%=site.getAgnt_nm()%></option>
        		    <%}%>
        		    <%for(int i = 0 ; i < mgr_size ; i++){
        			CarMgrBean mgr_bean = (CarMgrBean)car_mgrs.elementAt(i);
        			if(!mgr_bean.getMgr_email().equals("")){%>
        		    <option value="<%=mgr_bean.getMgr_nm()%>||<%=mgr_bean.getMgr_email()%>||<%=mgr_bean.getMgr_m_tel()%>" <%if(mgr_bean.getMgr_st().equals("�������")){%>selected<%}%>>[<%=mgr_bean.getMgr_st()%>] <%=mgr_bean.getMgr_email()%> <%=mgr_bean.getMgr_nm()%></option>
        		    <%}}%>	        				
        		</select>	            
	            </td>
	          </tr>			  			  
	          <tr>
	            <td width='10%' class='title'>�̸�</td>
	            <td width='90%'>&nbsp;
	                <input type='text' size='15' name='mgr_nm' value='<%=mgr.getMgr_nm()%>' maxlength='20' class='text' style='IME-MODE: active'></td>
	          </tr>
	          <tr>
	            <td class='title'>EMAIL</td>
	            <td>&nbsp;
	                <input type='text' size='40' name='mgr_email' value='<%=mgr.getMgr_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'></td>
	          </tr>
	          <tr>
	            <td class='title'>�̵���ȭ</td>
	            <td>&nbsp;
	              <input type='text' size='15' name='mgr_m_tel' value='<%=mgr.getMgr_m_tel()%>' maxlength='15' class='text'></td>
	          </tr>
	          <tr>
	            <td class='title'>����</td>
	            <td>&nbsp;
	              <input type="checkbox" name="mgr_cng" value="Y"> ���ڹ��� ������ ������ ������ڿ� ������Ʈ �Ѵ�.</td>
	          </tr>
            </table>
        </td>
    </tr>    
    <%    if(link_type.equals("2")){
    
    		//���°� Ȥ�� ���������϶� ����� ��������
		Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
		//���� ������ ��������
		car_mgrs = a_db.getCarMgrListNew(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd(), "Y");
		mgr_size = car_mgrs.size();	    
    %>
    <tr>
        <td class=h></td>
    </tr>    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ������ : <%=begin.get("FIRM_NM")%></span></td>
	</tr>        
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <tr>
	            <td class='title'>������</td>
	            <td>&nbsp;
                        <select name="suc_s_mail_addr"  onChange='javascript:suc_mail_addr_set();'>
			    <option value="">����</option>
        		    <%for(int i = 0 ; i < mgr_size ; i++){
        			CarMgrBean mgr_bean = (CarMgrBean)car_mgrs.elementAt(i);
        			if(!mgr_bean.getMgr_email().equals("")){%>
        		    <option value="<%=mgr_bean.getMgr_nm()%>||<%=mgr_bean.getMgr_email()%>||<%=mgr_bean.getMgr_m_tel()%>" <%if(mgr_bean.getMgr_st().equals("�������")){%>selected<%}%>>[<%=mgr_bean.getMgr_st()%>] <%=mgr_bean.getMgr_email()%> <%=mgr_bean.getMgr_nm()%></option>
        		    <%}}%>	        				
        		</select>	            
	            
	            </td>
	          </tr>			  			  
	          <tr>
	            <td width='10%' class='title'>�̸�</td>
	            <td width='90%'>&nbsp;
	                <input type='text' size='15' name='suc_mgr_nm' value='<%=suc_mgr.getMgr_nm()%>' maxlength='20' class='text' style='IME-MODE: active'></td>
	          </tr>
	          <tr>
	            <td class='title'>EMAIL</td>
	            <td>&nbsp;
	                <input type='text' size='40' name='suc_mgr_email' value='<%=suc_mgr.getMgr_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'></td>
	          </tr>
	          <tr>
	            <td class='title'>�̵���ȭ</td>
	            <td>&nbsp;
	              <input type='text' size='15' name='suc_mgr_m_tel' value='<%=suc_mgr.getMgr_m_tel()%>' maxlength='15' class='text'></td>
	          </tr>
            </table>
        </td>
    </tr>            
    <%    }%>
    <tr> 
        <td>&nbsp; 
            <%if(!link_type.equals("5")){%>* �ڵ���ü�� ��ϵǾ� �ִٸ� CMS�����ü ��û���� ��༭�� ���Ե˴ϴ�.<%}%>
        </td>
    </tr>    
    <tr>
        <td align="right">
		<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
		<%	if(!base.getCar_st().equals("4") && client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1") && (client.getRepre_ssn1().equals("")||client.getRepre_addr().equals(""))){%>
		* ����-���������� �����ε�. ��ǥ�� ������ϳ� �ּҰ� �����ϴ�. ����� ���ڰ�༭ �����ϼ���.
		<%	}else{%>
		<a href='javascript:link_send()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_send_econt.gif align=absmiddle border=0></a>&nbsp;
		<%	}%>
		<%}%>
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>   
    <%}else{%>
    <tr> 
        <td>* ���� ��� ������ �ֽ��ϴ�. </td>
    </tr>     
    <tr>
        <td align="right">
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    <%}%>	    
    
    <tr> 
        <td>&nbsp; </td>
    </tr>   
    <tr>
    	<td><input type="checkbox" name="email_chk" value="Y"> �̸����ּ� ������</td>
    </tr>        
    <tr>
        <td><input type="checkbox" name="send_alert" value="Y"> ���ڹ��� XML ���� Ȯ���Ѵ�.</td>
    </tr> 
        
    <tr> 
        <td>&nbsp; </td>
    </tr>    
    <tr> 
        <td>�� ����Ʈ ��༭�� ���������� �߼��մϴ�.</td>
    </tr>        
    <tr> 
        <td><font color=red><b>�� ������ ����Ʈ���� �̸����ּҸ� �����Ͽ� �������� �� �ֽ��ϴ�. (���� ��༭ ������ ����Ǿ��� ���� �̿�)</b></font> (2019-06-24 ����)</td>
    </tr>    
    <tr> 
        <td>�� ��༭ ���� ��  ��� > �����ؾ� �մϴ�. ������ ���к��� ���ڰ�༭ ��� > ������ ������ �ֽñ� �ٶ��ϴ�.(���� �߻� ���ɼ� ����)</td>
    </tr>      
<!--     <tr>  -->
<!--         <td><font color=red><b>�� �̸����̳� ���� ��߽��� ���Ǹ��� �����ؼ� ���ڰ����Ȳ-�۽����ڰ�༭-��߽��ϱ⿡�� ó���Ͻñ� �ٶ��ϴ�.</b></font></td> -->
<!--     </tr>     -->
<!--     <tr>  -->
<!--         <td>�� �¶��� ���ڰ�༭�� ���� ���Ǹ���(www.papyless.co.kr)�� �����ϸ� �˴ϴ�. ���̵�/�н������ ����/���λ���ڴ� ����ڹ�ȣ, ������ ���ݰ�꼭 ���� �̸����ּ��Դϴ�.</td> -->
<!--     </tr>         -->
<!--     <tr>  -->
<!--         <td>�� ���Ǹ��� ���ڰ�༭ �̿빮�� : ���Ǹ��� ��°� ���� 02-2638-7224, HP 010-6652-1000</td> -->
<!--     </tr>         -->
<!--     <tr>  -->
<!--         <td>�� ���� ���Ǹ��� ���ڰ�༭ �̿��ϸ鼭 ���������� ȣ�� �� ������ �߻��ϸ� ���� ��°����忡�� ���Ǹ� �ϸ� ��ȭ��� �� �������� ���� ������ �մϴ�.</td> -->
<!--     </tr>         -->
    		  
</table>
</form>
<!-- </center> -->
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
