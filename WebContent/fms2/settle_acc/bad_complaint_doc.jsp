<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.car_service.*, acar.forfeit_mng.*,acar.car_sche.*"%>
<%@ page import="acar.settle_acc.*, acar.cls.*, acar.fee.*, acar.cont.*,acar.client.*, acar.credit.*, acar.doc_settle.*, acar.ext.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();


	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");	
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");	
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_kd		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String today 		= request.getParameter("today")		==null?"":request.getParameter("today");
					
	String client_id 	= request.getParameter("client_id")	==null?"":request.getParameter("client_id");
	String page_st 		= request.getParameter("page_st")	==null?"":request.getParameter("page_st");	
	
	int    seq		= request.getParameter("seq")		==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String doc_no 		= request.getParameter("doc_no")	==null?"":request.getParameter("doc_no");
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");
	String idx 		= request.getParameter("idx")		==null?"":request.getParameter("idx");
	String req_mon 		= request.getParameter("req_mon")	==null?"":request.getParameter("req_mon");
	
					
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "07", "03");
	
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	
	//���� ��ฮ��Ʈ
	Vector conts = new Vector();
	int cont_size = 0;
	
	if(seq == 0){
		conts = s_db.getContComplaintList(client_id);
		cont_size = conts.size();
	}else{
		conts = s_db.getContComplaintList(client_id, seq);
		cont_size = conts.size();	
	}
	
		
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettleCommi("49", client_id+""+String.valueOf(seq));
	if(doc_no.equals("")){
		doc_no = doc.getDoc_no();
	}
	
	//�����
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	//�����������û
	BadComplaintReqBean bad_comp = s_db.getBadComplaintReq(client_id, seq);
	
			
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 20; //��Ȳ ��� �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	
	long total_amt 	= 0;
	long total_s_amt 	= 0;
	long total_v_amt 	= 0;
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "BAD_COMPLAINT_REQ";
	String content_seq  = client_id+""+seq;

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;		
	
	//������ ��� ��ȸ		
	t_wd = "������";
	
	Vector fines = FineDocDb.getFineGovLists("", "", t_wd);
	int fine_size = fines.size();
	
	
	Hashtable finesMail = FineDocDb.getFineDocMail(client_id);
	
	
/* 	//�ް��� ���			
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	String target_id ="";
	CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);  		
	if(!cs_bean2.getWork_id().equals("")) target_id =  cs_bean2.getWork_id(); //��ü�ٹ���
	System.out.println("��ü�ٹ��� "+target_id);	 */
	
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript">
<!--
	var popObj = null;
	
	//�˾������� ����
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}	
		theURL = "https://fms3.amazoncar.co.kr/data/bad_complaint_doc/"+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');			
		}else{
			popObj = window.open(theURL,'popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		popObj.location = theURL;
		popObj.focus();			
	}				
	
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		<%if(doc_no.equals("")){%>
		fm.action = '/acar/settle_acc/settle_s_frame.jsp?t_wd=<%=user_id%>';		
		<%}else{%>
		fm.action = '/fms2/settle_acc/bad_complaint_doc_frame.jsp?t_wd=""';		
		<%}%>	
		fm.mode.value = '';
		fm.target = 'd_content';	
		fm.submit();
	}	
		
	//�����ϱ�
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
			
		if(doc_bit == '1'){
			if(fm.bad_cau.value == '')	{ alert('��û������ �Է��Ͻʽÿ�.'); 				return; }
		}else if (doc_bit == '4'  ){  //���������� ���� �߰� 
			<%if(!doc.getUser_dt1().equals("")){%>	
		
			if(fm.bad_yn.value == '')	{ alert('���౸���� �Է��Ͻʽÿ�.'); 				return; }
			
			<%}%>
		}else if (doc_bit == '2'   ){
			<%if(!doc.getUser_dt4().equals("")){%>	
			if(fm.bad_yn.value == 'Y' && fm.file_name1.value == '')	{ alert('������� ��ĵ�Ͻʽÿ�.'); 	return; }
			if(fm.bad_yn.value == '')	{ alert('���౸���� �Է��Ͻʽÿ�.'); 				return; }
			if(fm.bad_yn.value == 'Y' ) {
				if($("#pol_place").val()=="" || $("#pol_place").val()==null){	alert("���� �������� ������ �ֽʽÿ�.");	return;	}
			}
			<%}%>	
		}else if(doc_bit == '3'){
			<%if(!doc.getUser_dt2().equals("")){%>	
			if(fm.bad_st.value == '')	{ alert('ó�������� �����Ͻʽÿ�.'); 				return; }		
			<%}%>
		}		
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='bad_complaint_doc_sanction.jsp';		
			fm.target='i_no';
			//fm.target='_blank';
			fm.submit();
		}									
	}
	
	//�����ϱ�
	function doc_sanction_etc(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('ó���Ͻðڽ��ϱ�?')){	
			fm.action='bad_complaint_doc_a.jsp';		
			fm.target='i_no';
			//fm.target='_blank';
			fm.submit();
		}									
	}	
		
	//�Ⱒ�ϴ� �������̱�
	function display_reject(){
		var fm = document.form1;
		
		if(fm.bad_st.value =='3' || fm.bad_st.value =='2'){ 	//�Ⱒ,����
			tr_reject.style.display	= '';
		}else{							//����
			tr_reject.style.display	= 'none';
		}
	}

	//��ĵ��Ϻ��̱�
	function display_scan(idx){
		var fm = document.form1;
		
		if(idx == 1){
			if(fm.bad_yn.value =='Y'){
				tr_scan1.style.display	= '';
				tr_reject.style.display	= 'none';
			}else{			
				tr_scan1.style.display	= 'none';
				tr_reject.style.display	= '';
			}		
		}
		
	}
		
	//��ĵ���� ����
	function view_scan(m_id, l_cd)
	{
		window.open("/fms2/lc_rent/view_scan.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=800, scrollbars=yes");				
	}
	
	//�����ٺ���
	function view_scd(m_id, l_cd){
	//	window.open("/fms2/con_fee/fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "VIEW_SCD", "left=100, top=100, width=820, height=700, scrollbars=yes");
		var today = new Date().toISOString().slice(0,10);
		var user_dt1 ='<%=doc.getUser_dt1()%>';
		if(!user_dt1) user_dt1= today;
		
		user_dt1 = user_dt1.replace(/-/gi,'');
	 	window.open("/fms2/con_fee/fee_scd_print_ext.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&doc_dt1="+user_dt1+"", "VIEW_SCD", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	

	//�ߵ���������  ����
	function view_settle(m_id, l_cd){
		window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
	}	
	
	//�뿩��޸�
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=2&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0&mode=credit_doc", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
	}	
	
	//��ĵ���
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&client_id=<%=client_id%>&seq=<%=seq%>&doc_no=<%=doc_no%>&from_page=/fms2/settle_acc/bad_complaint_doc.jsp&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//���ΰ�ħ
	function page_reload(){
		var fm = document.form1;
		fm.action='bad_complaint_doc.jsp';		
		fm.target='d_content';
		fm.submit();		
	}
	
	// �������� ���		2018.01.17
	function view_comp_cancel(seq, client_id){
		var gubun = "";
		var crime = "";
		gubun = document.getElementsByName("select_comp_cancel")[0].value;
		crime = document.getElementsByName("select_crime_name")[0].value;
		if(gubun=="0"){
			alert("�������� ������ ������ �ּ���!");
			document.getElementsByName("select_comp_cancel")[0].focus();
			return;
		}
		/* if(crime=="0"){	
		} */
		window.open("./bad_complaint_doc_cancel.jsp?seq="+seq+"&client_id="+client_id+"&gubun="+gubun+"&crime="+crime, "COMPLAINT_CANCEL", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}
	
	
	//�ȳ����Ϲ߼� ����
	function doc_email_view(doc_id, title){
		var fm = document.form1;
		if (title == '������� �� �����ְ�' ) {
			fm.action="/mailing/pay/cont_cancel_3.jsp?doc_id="+doc_id;	
		} else if (title == '������� �� �����ݳ� �뺸' ) {
			fm.action="/mailing/pay/cont_cancel_re2.jsp?doc_id="+doc_id;			
	//	} else if (title == '������ ���׺� �����ְ�' ) {
	//		fm.action="/mailing/pay/myaccid_cancel.jsp?doc_id="+doc_id;	
		} else {
			fm.action="/mailing/pay/cont_cancel_4.jsp?doc_id="+doc_id;				
		}
		fm.target="_blank";
		fm.submit();
	}	
	//�޾ȳ����Ϲ߼�
	function doc_email(){
	   
		var fm = document.form1;
			
		if(confirm('������ �߼��ϰڽ��ϱ�?')){	
			fm.action="cont_cancel_doc_mail_a.jsp";			
			fm.target='i_no';
			fm.submit();
		}											
	}
	//���Ұ����� �˻�
	function search_police(){
		var fm = document.form1;
		var police_text= fm.police_text.value;
		if(police_text == ""){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.police_text.focus(); return; }	
		  var url = 'police_search.jsp?t_wd='+police_text;
		window.open(url,'',"top=300,left=400, width=600, height=400, scrollbars=yes");  
	}
	
	function enterkey() {
        if (window.event.keyCode == 13) {
        	search_police();
        }
	}

	$(document).ready(function(){
		
		var police = $("#police").val();		
		$("#pol_place option[value='"+police+"']").prop("selected", true); // ���� ������ ����
		
	});	
</script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='bad_complaint_doc_sanction.jsp' method='post' target=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
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

<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='page_st' value='<%=page_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name="doc_no" value="<%=doc_no%>">
<input type='hidden' name="doc_bit" value="">
<input type='hidden' name="firm_nm" value="<%=client.getFirm_nm()%>">
<input type="hidden" id="police" value="<%=bad_comp.getPol_place()%>">
<input type="hidden" name="client_st" value="<%=client.getClient_st()%>"><!-- �������� select box ������ ���� �߰� 2018.01.18 -->
<input type='hidden' name="doc_id" value="<%=finesMail.get("DOC_ID")%>">
<input type='hidden' name="gov_nm" value="<%=finesMail.get("GOV_NM")%>">
<input type='hidden' name="doc_title" value="<%=finesMail.get("TITLE")%>">
<input type='hidden' name="email" value="<%=finesMail.get("REMARKS")%>">


<div class="navigation" style="margin-bottom:0px !important">
<span class="style1">FMS����� > ���ڹ������� > </span><span class="style5">����� ������û </span>
</div>
<div align="right">
	<input type="button" value="���" class="button" onclick="javascript:go_to_list()">
<!--	<%if(doc_no.equals("")){%><input type="button" value="���" class="button" onclick="javascript:history.go(-1)"><%}%> -->
</div>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

    <tr id=tr_acct1 style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">  
        <td colspan="2">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>	
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� (<%=client_id%>)</span></td>
    		    </tr>
    		    <tr>
    		        <td class=line2></td>
    		    </tr>
    		    <tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td colspan="2" class='title'>��������</td>
            		            <td>&nbsp;
            		                <%= client.getFound_year()%></td>
            		            <td class='title'>��������</td>
            		            <td>&nbsp;
            		                <%= client.getOpen_year()%></td>
            		        </tr>
            		        <tr>
            		            <td width='8%' rowspan="5" class='title'>��<br>
                					��<br>
                					��<br>
                					��<br>
                					��<br>
                					��</td>
            		            <td width="13%" class='title'>��ȣ</td>
            		            <td width="33%" align='left'>&nbsp;<%=client.getFirm_nm()%></td>
            		            <td class='title' width=13%>��ǥ��</td>
            		            <td width="33%">&nbsp;<%=client.getClient_nm()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����ڹ�ȣ<br/>
            		            </td>
            		            <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>
								<%if(!client.getTaxregno().equals("")){%>
								(������ڹ�ȣ:<%=client.getTaxregno()%>)
								<%}%>
								</td>
            		            <td class='title'>���ι�ȣ</td>
            		            <td>&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����� �ּ�</td>
            		            <td colspan='3'>&nbsp;
                        		              <%if(!client.getO_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getO_zip()%> 
                        		              <%if(!client.getO_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getO_addr()%>
                        		</td>
            		        </tr>									
            		        <tr>
            		            <td class='title'>����������</td>
            		            <td colspan='3'>&nbsp;
            		            <%if(!client.getHo_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getHo_zip()%> 
            		              <%if(!client.getHo_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getHo_addr()%>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����</td>
            		            <td>&nbsp;<%=client.getBus_cdt()%></td>
            		            <td class='title'>����</td>
            		            <td>&nbsp;<%=client.getBus_itm()%></td>
            		        </tr>
            		        <tr>
            		            <td rowspan="3" class='title'>��<br>
                					ǥ<br>
                					��</td>
            		            <td class='title'>��ǥ�ڱ���</td>
            		            <td>&nbsp;
            		            <%if (client.getRepre_st().equals("1")){%>
            		            	��������
            		            <%} else if (client.getRepre_st().equals("2")){%>
            		            	�����濵��
            		            <%}%>
            			        <%-- <%if(client.getRepre_st().equals("1")) 		out.println("��������");
            	                   	else if(client.getRepre_st().equals("2"))	out.println("�����濵��");%> --%>
            	                </td>
            		            <td class='title'>�������</td>
            		            <td>&nbsp;<%=client.getRepre_ssn1()%></td>				  
            				</tr>
            		        <tr>
            		            <td class='title'>�ּ�</td>
            		            <td colspan="3">
            		                <table width=100% border=0 cellspacing=0 cellpadding=3>
            		                    <tr>
            		                        <td>
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getRepre_zip()%> 
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getRepre_addr()%>
                        		            </td>
                        		        </tr>
                        		    </table>
                        		</td>
            		        </tr>
            		        <tr>
            		            <td class='title'>�޴�����ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
            		            <td class='title'>���ù�ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>�繫�ǹ�ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
            		            <td class='title'>�ѽ���ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
            		        </tr>
    		            </table>
    			    </td>
    		    </tr>
        	</table>
	    </td>
    </tr>	  
    <tr id=tr_acct2 style="display:<%if(client.getClient_st().equals("1") || client.getClient_st().equals("2") ){%>none<%}else{%>''<%}%>">
	    <td colspan="2">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���λ���� (<%=client_id%>)</span></td>
    		    </tr>
    		    <tr>
                    <td class=line2 colspan=2></td>
                </tr> 
    		    <tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td width='3%' rowspan="5" class='title'>��<br>
                			      ��<br>
                			      ��<br>
                			      ��<br>
                		    	  ��<br>
                			      ��</td>
            		            <td class='title' width='10%'>��������� </td>
            		            <td colspan="3">&nbsp;<%= client.getOpen_year()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>��ȣ</td>
            		            <td width="37%" align='left'>&nbsp;<%= client.getFirm_nm()%></td>
            		            <td class='title'>��ǥ��</td>
            		            <td width="37%">&nbsp;<%= client.getClient_nm()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����ڹ�ȣ<br/>
            		            </td>
            		            <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
            		            <td class='title'>�������</td>
            		            <td>&nbsp;<%=client.getSsn1()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����� ������</td>
            		            <td colspan='3'>&nbsp;
            		              <%if(!client.getO_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getO_zip()%> 
            		              <%if(!client.getO_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getO_addr()%>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>����</td>
            		            <td>&nbsp;<%= client.getBus_cdt()%></td>
            		            <td class='title'>����</td>
            		            <td>&nbsp;<%= client.getBus_itm()%></td>
            		        </tr>            		     
            		        <tr>
            		            <td rowspan="2" class='title'>��<br>
            					ǥ<br>
            					��</td>
            		            <td class='title'>�������</td>
            		            <td>&nbsp;<%=client.getRepre_ssn1()%></td>
            		            <td class='title'>�ּ�</td>
            		            <td>
            		                <table width=100% border=0 cellspacing=0 cellpadding=3>
            		                    <tr>
            		                        <td>
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getRepre_zip()%> 
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getRepre_addr()%>
                        		            </td>
                        		        </tr>
                        		    </table>
                        		</td>
            				</tr>
            		        <tr>
            		            <td class='title'>�޴�����ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
            		            <td class='title'>���ù�ȣ</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
            		        </tr>		     
            		        <tr>
            		            <td colspan="2" class='title'>�繫�ǹ�ȣ</td>
            		            <td>&nbsp;<%= client.getO_tel()%></td>
            		            <td class='title'>�ѽ���ȣ</td>
            		            <td>&nbsp;<%= client.getFax()%></td>
            		        </tr>
    		            </table>
    			    </td>
    		   </tr>
        	</table>
	    </td>
    </tr>	    
    <tr id=tr_acct3 style="display:<%if(client.getClient_st().equals("2")){%>''<%}else{%>none<%}%>"> 
	<td colspan="2">
	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 	  
    		<tr>
    		    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� (<%=client_id%>)</span></td>
    		</tr>
    		<tr>
    		    <td class=line2></td>
    		</tr>
    		<tr>
    		    <td class=line>
        		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
        		        <tr>
        		            <td width='10%' class='title'>����</td>
        		            <td width='15%' align='left'>&nbsp;<%=client.getFirm_nm()%></td>
        		            <td width='10%' class='title'>�������</td>
        		            <td width='15%' >&nbsp;<%=client.getSsn1()%></td>
        		            <td width='10%' class='title'>�����ּ�</td>
        		            <td colspan='3'>&nbsp;
        		         	  <%if(!client.getHo_addr().equals("")){%>
        		              ( 
        		              <%}%>
        		              <%=client.getHo_zip()%> 
        		              <%if(!client.getHo_addr().equals("")){%>
        		              )&nbsp; 
        		              <%}%>
        		              <%=client.getHo_addr()%>
        					    </td>
        		        </tr>
        		        <tr>
        		            <td class='title'>�޴���</td>
        		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
        		            <td class='title'>������ȭ��ȣ</td>
        		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
        		            <td class='title'>����</td>
        		            <td>&nbsp;<%if(client.getNationality().equals("2")){%>�ܱ���<%}else{%>������<%}%>
		            	    </td>
        		            <td width='10%' class='title'>Homepage</td>
        		            <td width='15%'>&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
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
	    <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ��� ���뿩���</span></td>	    
	</tr>
	<tr>
	    <td>
    		<table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
    		        <td class=line2></td>
    		    </tr>
    		    <tr>
        			<td class='line'>
        			    <table border="0" cellspacing="1" cellpadding="0" width=100%>
            				<tr>
            				    <td width='3%' class=title>����</td>
            				    <td width='10%' class=title>����ȣ</td>
            				    <td width='10%' class=title>�����</td>
            				    <td width='8%' class=title>��ǥ��������</td>
            				    <td width='8%' class=title>��ǥ���뺸��</td>
            				    <td width='7%' class=title>��������</td>            				    
            				    <td width='10%' class=title>������</td>
            				    <td width='15%' class=title>����</td>
            				    <td width='8%' class=title>������ȣ</td>
            				    <td width='8%' class=title>��������</td>
            				    <td width='8%' class=title>���ʵ����</td>
            				    <td width='5%' class=title>��ĵ</td>
            				</tr>
<%
	if(cont_size > 0)
	{
		for(int i = 0 ; i < cont_size ; i++)
		{
			Hashtable cont = (Hashtable)conts.elementAt(i);			
%>
				<tr>
					<td align='center'><%=i+1%>
					  <input type='hidden' name='item_seq' value='<%=i+1%>'>
					  <input type='hidden' name='rent_mng_id' value='<%=cont.get("RENT_MNG_ID")%>'>
					  <input type='hidden' name='rent_l_cd' value='<%=cont.get("RENT_L_CD")%>'>
					</td>
					<td align='center'><%=cont.get("RENT_L_CD")%></td>
					<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(cont.get("RENT_DT")))%>
					  <%if(!String.valueOf(cont.get("RENT_SUC_DT")).equals("")){%>
					  <br>[�°�]<%=AddUtil.ChangeDate2(String.valueOf(cont.get("RENT_SUC_DT")))%>
					  <%}%>
					</td>
					<td align='center'><%=cont.get("CLIENT_SHARE_ST")%></td>		
					<td align='center'><%=cont.get("CLIENT_GUAR_ST")%></td>		
					<td align='center'><%=cont.get("CAR_GU")%></td>		
					<td align='center'><%=cont.get("CAR_COMP_NM")%></td>							
					<td align='center'><%=cont.get("CAR_NM")%>&nbsp;<%=cont.get("CAR_NAME")%></td>
					<td align='center'><%=cont.get("CAR_NO")%></td>
					<td align='right'><%if(String.valueOf(cont.get("CAR_GU")).equals("����")){%><%=Util.parseDecimal(String.valueOf(cont.get("CAR_AMT")))%><%}else{%><%=Util.parseDecimal(String.valueOf(cont.get("SH_AMT")))%><%}%>��</td>
					<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
					<td align='center'><a href="javascript:view_scan('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ĵ����'><img src=/acar/images/center/button_in_scan.gif align=absmiddle border=0></a></td>
				</tr>
<%			
		}
	}
%>    	            				
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
	    <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩��� ����</span></td>	    
	</tr>
	<tr>
	    <td>
    		<table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
    		        <td class=line2></td>
    		    </tr>
    		    <tr>
        			<td class='line'>
        			    <table border="0" cellspacing="1" cellpadding="0" width=100%>
            				<tr>            				
            				    <td width='3%' class=title>����</td>
            				    <td width='10%' class=title>����ȣ</td>
            				    <td width='23%' class=title>���Ⱓ</td>
            				    <td width='23%' class=title>���ǿ���</td>            				    
            				    <td width='9%' class=title>������</td>
            				    <td width='9%' class=title>������</td>
            				    <td width='8%' class=title>���ô뿩��</td>            				    
            				    <td width='7%' class=title>�ſ�������</td>
            				    <td width='8%' class=title>���뿩��</td>            				    
            				</tr>
<%
	if(cont_size > 0)
	{
		for(int i = 0 ; i < cont_size ; i++)
		{
			Hashtable cont = (Hashtable)conts.elementAt(i);			
%>
				<tr>
					<td align='center'><%=i+1%></td>
					<td align='center'><%=cont.get("RENT_L_CD")%></td>
					<td align='center'><%if(seq==0 && !String.valueOf(cont.get("T_CNT")).equals("1")){%>[<%=cont.get("T_CNT")%>��]<%}%><input type='text' name='t_rent_start_dt' value='<%=AddUtil.ChangeDate2(String.valueOf(cont.get("T_RENT_START_DT")))%>' size='11' class='text'>~<input type='text' name='t_rent_end_dt' value='<%=AddUtil.ChangeDate2(String.valueOf(cont.get("T_RENT_END_DT")))%>' size='10' class='text'>(<input type='text' name='t_con_mon' value='<%=cont.get("T_CON_MON")%>' size='2' class='text'>����)</td>
					<td align='center'>
					  <%if(!String.valueOf(cont.get("ADD_RENT_START_DT")).equals("")){%>
					    <%if(seq==0 && !String.valueOf(cont.get("ADD_CNT")).equals("1")){%>[<%=cont.get("ADD_CNT")%>��]<%}%><input type='text' name='add_rent_start_dt' value='<%=AddUtil.ChangeDate2(String.valueOf(cont.get("ADD_RENT_START_DT")))%>' size='11' class='text'>~<input type='text' name='add_rent_end_dt' value='<%=AddUtil.ChangeDate2(String.valueOf(cont.get("ADD_RENT_END_DT")))%>' size='10' class='text'>(<input type='text' name='add_tm' value='<%=cont.get("ADD_TM")%>' size='2' class='text'>ȸ��)
					  <%}else{%>
					    -
					    <input type='hidden' name='add_rent_start_dt' value=''>
					    <input type='hidden' name='add_rent_end_dt' value=''>
					    <input type='hidden' name='add_tm' value=''>
					  <%}%>
					</td>					
					<td align='right'><%=Util.parseDecimal(String.valueOf(cont.get("GRT_AMT_S")))%>��</td>
					<td align='right'><%=Util.parseDecimal(String.valueOf(cont.get("PP_AMT")))%>��</td>		
					<td align='right'><%=Util.parseDecimal(String.valueOf(cont.get("IFEE_AMT")))%>��</td>		
					<td align='center'><%if(String.valueOf(cont.get("FEE_EST_DAY")).equals("99")){%>����<%}else{%><%=cont.get("FEE_EST_DAY")%>��<%}%></td>
					<td align='right'><%=Util.parseDecimal(String.valueOf(cont.get("FEE_AMT")))%>��</td>		
				</tr>
<%			
		}
	}
%>    	            				
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
	    <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ݰ� �뿩��� �ߵ����� </span></td>	    
	</tr>
	<tr>
	    <td>
    		<table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
    		        <td class=line2></td>
    		    </tr>
    		    <tr>
        			<td class='line'>
        			    <table border="0" cellspacing="1" cellpadding="0" width=100%>
            				<tr>            				
            				    <td width='3%' class=title>����</td>
            				    <td width='10%' class=title>����ȣ</td>
            				    <td width='6%' class=title>����ȸ��</td>
            				    <td width='23%' class=title>��⿬ü</td>
            				    <td width='8%' class=title>ä�Ǳݾ�</td>
            				    <td width='5%' class=title>������</td>
            				    <td width='5%' class=title>���꼭</td>
            				    <td width='35%' class=title>�ְ���</td>
            				    <td width='5%' class=title>�޸�</td>
            				</tr>
<%
	if(cont_size > 0)
	{
		for(int i = 0 ; i < cont_size ; i++)
		{
			Hashtable cont = (Hashtable)conts.elementAt(i);			
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(cont.get("DLY_FEE_AMT")));
%>
				<tr>
					<td align='center'><%=i+1%></td>
					<td align='center'><%=cont.get("RENT_L_CD")%></td>
					<td align='center'><input type='text' name='a_fee_tm' value='<%=cont.get("A_FEE_TM")%>' size='2' class='text'>ȸ��</td>
					<td align='center'>
					  <input type='text' name='fee_tm' value='<%=cont.get("FEE_TM")%>' size='2' class='text'>ȸ��
					  <input type='text' name='fee_est_dt' value='<%=cont.get("FEE_EST_DT")%>' size='9' class='text'>����
					  <input type='text' name='dly_mon' value='<%=cont.get("DLY_MON")%>' size='2' class='text'>���� ��ü
					</td>
					<td align='right'>
					  <input type='text' name='dly_fee_amt' value='<%=Util.parseDecimal(String.valueOf(cont.get("DLY_FEE_AMT")))%>' size='9' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>��
					</td>
					<td align='center'><a href="javascript:view_scd('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='�����ٰ���'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
					<td align='center'><a href="javascript:view_settle('<%=cont.get("RENT_MNG_ID")%>','<%=cont.get("RENT_L_CD")%>');" class="btn" title='�����ϱ�'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
					<td align='center'><input type='text' name='credit_doc_id' value='<%=cont.get("DOC_ID")%>' size='18' class='text'>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cont.get("DOC_DT")))%>&nbsp;<%=cont.get("TITLE")%></td>					
					<td align='center'><a href="javascript:view_memo('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='�޸𺸱�'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
				</tr>
<%		}%>
				<tr>
					<td class=title colspan='4'>�հ�</td>
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��</td>
					<td class=title colspan='4'>&nbsp;</td>
				</tr>


<%	}%>    	            				
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
        <td ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����������û</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="13%">��û����</td>
                    <td>&nbsp;<textarea cols="100" rows="5" name="bad_cau"><%=bad_comp.getBad_cau()%></textarea></td>
                </tr>		
		<%if(!doc.getUser_dt1().equals("")){%>	
                <% if(doc.getUser_dt2().equals("") ){%>	
                <tr> 
                    <td class='title'>���౸��</td>
                    <td>&nbsp;
                      <select name='bad_yn' <%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%>onchange="javascript:display_scan(1);"<%}%> class='default' <%if(doc.getDoc_step().equals("3")){%>disabled<%}%> >
                        <option value="">����</option>
						<option value="Y" <%if(bad_comp.getBad_yn().equals("Y"))%>selected<%%>>����</option>
						<option value="N" <%if(bad_comp.getBad_yn().equals("N"))%>selected<%%>>������</option>			
			                      </select>
					    </td>
                </tr>
                <tr><!-- ���λ���� �������� fms ��û �� �ѽ��߼� ���Ȱ� ���� 2018.01.17 -->
                	<td class='title'>��������</td>
                	<td>&nbsp;
                		<label>���� :</label>
                		<select name="select_comp_cancel" class="default">
                			<option value="0">����</option>
                			<option value="1">�����ݳ�</option>
                			<option value="2">�뿩�ᳳ��</option>
                		</select>
                		<label>�˸� :</label>
                		<select name="select_crime_name" class="default">
                			<option value="0" selected>Ⱦ��</option>
                		</select>
                		<input type="button" value="���" style="font-size:11px;margin-top:3px;margin-bottom:3px;" onclick="javascript:view_comp_cancel('<%=seq%>','<%=client_id%>')" onMouseOver="window.status=''; return true" title='�������� ���'>
               				
                		<span style="margin-left:50px;"></span>
                		<input type="button" value="����Ȯ��" style="font-size:11px;margin-top:3px;margin-bottom:3px;cursor:pointer;" onclick="javascript:doc_email_view('<%=finesMail.get("DOC_ID")%>', '<%=finesMail.get("TITLE")%>')">
                		<input type="button" value="������" style="font-size:11px;margin-top:3px;margin-bottom:3px;cursor:pointer;" onclick="javascript:doc_email()">
                	</td>
                </tr>
                 <tr>
                	<td class='title'>���� ������</td>
                	<td>&nbsp;
                		<input type="text" name="police_text" onkeypress="enterkey();"  style="font-size:11px;"/>
                		<input type="button" name="police_btn "value="�˻�" style="font-size:11px;margin-top:3px;margin-bottom:3px;cursor:pointer;" onclick="javascript:search_police()">
                		<select id="pol_place" name="pol_place">
                			<option value="">����</option>
                			<%for(int i = 0 ; i < fine_size ; i++){
								FineGovBn = (FineGovBean)fines.elementAt(i);%>
								<option value="<%=FineGovBn.getGov_id()%>" <%-- hidden="<%=FineGovBn.getGov_nm()%>" --%>><%=FineGovBn.getGov_nm()%></option>
							<%}%>
                		</select>
                	</td>
                </tr>				  				                
                <tr id=tr_scan1 style="display:<%if(bad_comp.getBad_yn().equals("Y") || !bad_comp.getFile_name1().equals("")){%>''<%}else{%>none<%}%>"> 
                    <td class='title'>����彺ĵ</td>
                    <td>&nbsp;
                      
                 <%
                 	content_seq  = client_id+""+seq+"1";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%><input type='hidden' name='file_name1' value='<%=attach_ht.get("FILE_NAME")%>'>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>
    						<input type='hidden' name='scan_yn' value='Y'>        		        		
    						<%}else{%>		
    						<input type='hidden' name='scan_yn' value='N'>        		        		
    						<%}%>
    								      
        		&nbsp;&nbsp;<span class="b"><a href="javascript:scan_reg('1')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
			&nbsp;&nbsp;* ��ĵ������ ����ϰ��� �� �������� <a href="javascript:page_reload()">���ΰ�ħ</a> ���ּ��� 			        	      
                    </td>
                </tr>   
                <tr id=tr_reject style="display:''"> 
                    <td class='title'>���������</td>
                    <td>&nbsp;<textarea cols="100" rows="5" name="reject_cau"><%=bad_comp.getReject_cau()%></textarea></td>
                </tr>
                <%	}else{%>
                <tr> 
                    <td class='title'>���౸��</td>
                    <td>&nbsp;
                      <select name='bad_yn' <%if(doc.getDoc_step().equals("3")){%>disabled<%}%> >
                        <option value="">����</option>
						<option value="Y" <%if(bad_comp.getBad_yn().equals("Y"))%>selected<%%>>����</option>
						<option value="N" <%if(bad_comp.getBad_yn().equals("N"))%>selected<%%>>������</option>			
                      </select>
		    		</td>
                </tr>
                <tr><!-- ����, ���� �������� fms ��û �� �ѽ��߼� ���Ȱ� ���� 2018.01.17 -->
                	<td class='title'>��������</td>
                	<td>&nbsp;
                		<label>���� :</label>
                		<select name="select_comp_cancel" class="default">
                			<option value="0">����</option>
                			<option value="1">�����ݳ�</option>
                			<option value="2">�뿩�ᳳ��</option>
                		</select>
                		<label>�˸� :</label>
                		<select name="select_crime_name" class="default">
                			<option value="0" selected>Ⱦ��</option>
                		</select>
                		<input type="button" value="���" style="font-size:11px;margin-top:3px;margin-bottom:3px;" onclick="javascript:view_comp_cancel('<%=seq%>','<%=client_id%>')" onMouseOver="window.status=''; return true" title='�������� ���'>
                		<%-- <a href="javascript:doc_email_view('<%=finesMail.get("DOC_ID")%>', '<%=finesMail.get("TITLE")%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> --%>
                		
                		<span style="margin-left:50px;"></span>
                		<input type="button" value="����Ȯ��" style="font-size:11px;margin-top:3px;margin-bottom:3px;cursor:pointer;" onclick="javascript:doc_email_view('<%=finesMail.get("DOC_ID")%>', '<%=finesMail.get("TITLE")%>')">
                		<input type="button" value="������" style="font-size:11px;margin-top:3px;margin-bottom:3px;cursor:pointer;" onclick="javascript:doc_email()">
                	</td>
                </tr>
                <tr>
                	<td class='title'>���� ������</td>
                	<td>&nbsp;
                		<input type="text" name="police_text" onkeypress="enterkey();"  style="font-size:11px;"/>
                		<input type="button" name="police_btn "value="�˻�" style="font-size:11px;margin-top:3px;margin-bottom:3px;cursor:pointer;" onclick="javascript:search_police()">
                		<span style="margin-left:85px;"></span>	
                		<select id="pol_place" name="pol_place">
                			<option value="">����</option>
                			<%for(int i = 0 ; i < fine_size ; i++){
								FineGovBn = (FineGovBean)fines.elementAt(i);%>
								<option value="<%=FineGovBn.getGov_id()%>" <%-- hidden="<%=FineGovBn.getGov_nm()%>" --%>><%=FineGovBn.getGov_nm()%></option>
							<%}%>
                		</select>
                	</td>
                </tr>				                                											
                <tr> 
                    <td class='title'>ó������</td>
                    <td>&nbsp;
                      <select name='bad_st' <%if(!doc.getUser_dt1().equals("")){%>onchange="javascript:display_reject();"<%}%>  <%if(bad_comp.getBad_st().equals("1")){%>disabled<%}%> >
                        <option value="">����</option>
						<option value="1" <%if(bad_comp.getBad_st().equals("1"))%>selected<%%>>����(���������)</option>
						<option value="2" <%if(bad_comp.getBad_st().equals("2"))%>selected<%%>>����</option>
						<option value="3" <%if(bad_comp.getBad_st().equals("3"))%>selected<%%>>�Ⱒ</option>
                      </select>
                      <%if(bad_comp.getBad_st().equals("2")){%>
                      <%	if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�������",user_id) || nm_db.getWorkAuthUser("�����������",user_id) ){%>
                      &nbsp;&nbsp;&nbsp;
                      ->
                      &nbsp;&nbsp;&nbsp;
                      <select name='bad_st2'>
                        <option value="">����</option>
						<option value="1" <%if(bad_comp.getBad_st().equals("1"))%>selected<%%>>����(���������)</option>
						<option value="2" <%if(bad_comp.getBad_st().equals("2"))%>selected<%%>>����</option>
						<option value="3" <%if(bad_comp.getBad_st().equals("3"))%>selected<%%>>�Ⱒ</option>
                      </select>
                      <a href="javascript:doc_sanction('a');">[�����ó��]</a>
                      <%	}%>
                      <%}%>
					</td>
                </tr>				
                
                <%if(bad_comp.getBad_st().equals("3")||bad_comp.getBad_st().equals("2") || bad_comp.getBad_yn().equals("N") ){ %>
	                <tr id=tr_reject> 
	                    <td class='title'><% if ( bad_comp.getBad_yn().equals("N") ) {%>���������<% } else {%>����<% } %></td>
	                    <td>&nbsp;<textarea cols="100" rows="5" name="reject_cau"><%=bad_comp.getReject_cau()%></textarea></td>
	                </tr>
                <%}else{%>
                	<tr id=tr_reject style='display:none'> 
	                    <td class='title'><% if ( bad_comp.getBad_yn().equals("N") ) {%>���������<% } else {%>����<% } %></td>
	                    <td>&nbsp;<textarea cols="100" rows="5" name="reject_cau"><%=bad_comp.getReject_cau()%></textarea></td>
	                </tr>
                <%}%>                
		<%	}%>
		<%}%>
           </table>
        </td>
    </tr>	
    <%if(!doc.getUser_dt2().equals("") && bad_comp.getBad_yn().equals("Y")){%>			
    <tr>
        <td class=h></td>
    </tr>				
    <tr> 
        <td ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ĵ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="13%">�����</td>
                    <td>&nbsp;
		      
                 <%
                 	content_seq  = client_id+""+seq+"1";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%><input type='hidden' name='file_name1' value='<%=attach_ht.get("FILE_NAME")%>'>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>    						
    						<%}%>		

		      
        		&nbsp;&nbsp;<span class="b"><a href="javascript:scan_reg('1')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
                    </td>
                </tr> 
                <%if(!doc.getUser_dt3().equals("") && bad_comp.getBad_st().equals("1")){%>	
                <tr> 
                    <td class='title' width="13%">������</td>
                    <td>&nbsp;
		      
                 <%
                 	content_seq  = client_id+""+seq+"2";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>    						
    						<%}%>	
    								      
        		&nbsp;&nbsp;<span class="b"><a href="javascript:scan_reg('2')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
                    </td>
                </tr>
                <%	if(!bad_comp.getReq_dt().equals("")){%>
                <%		if(!bad_comp.getCar_call_yn().equals("N")){%>	                 
                <tr> 
                    <td class='title' width="13%">�����</td>
                    <td>&nbsp;                                            		      
                 <%
                 	content_seq  = client_id+""+seq+"3";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>    						
    						<%}%>	
    								      
        		&nbsp;&nbsp;<span class="b"><a href="javascript:scan_reg('3')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
                    </td>
                </tr>    
                <%		}%>     
                <%		if(!bad_comp.getCar_call_yn().equals("Y")){%>	                         
                <tr> 
                    <td class='title' width="13%">�����ǰṮ</td>
                    <td>&nbsp;                                        
		      
                 <%
                 	content_seq  = client_id+""+seq+"4";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
								
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>    						
    						<%}%>	
    								      
        		&nbsp;&nbsp;<span class="b"><a href="javascript:scan_reg('4')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>			
                    </td>
                </tr>   
                <%		}%>                  
                <%	}%>
                <%}%>  
           </table>
        </td>
    </tr>   
    <tr>
        <td>* ��ĵ������ ����ϰ��� �� �������� <a href="javascript:page_reload()">���ΰ�ħ</a> ���ּ��� 	</td>
    </tr>     
    <%}%>    
    <%if(!doc.getUser_dt3().equals("") && bad_comp.getBad_st().equals("1")){%>			
    <tr>
        <td class=h></td>
    </tr>				
    <tr> 
        <td ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ó�����</span></td>
    </tr>
    <tr>
        <td class=line2></td>        
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>��������</td>
                    <td>&nbsp;
        		<input type='text' name='req_dt' size='11' value='<%=AddUtil.ChangeDate2(bad_comp.getReq_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
        		<%if(bad_comp.getReq_dt().equals("") && !bad_comp.getFile_name2().equals("")){%>
        		<a href="javascript:doc_sanction_etc('req');">[����ó��]</a>
        		<%}else{%>
        		* ������ ���� ��ĵ�Ͻʽÿ�.
        		<%}%>
        	    </td>
        		
                </tr>
                <%if(!bad_comp.getReq_dt().equals("")){%>
                <tr> 
                    <td class='title'>����ȸ������</td>
                    <td>&nbsp;
                      <select name='car_call_yn' >
                        <option value="">����</option>
			<option value="Y" <%if(bad_comp.getCar_call_yn().equals("Y"))%>selected<%%>>ȸ��</option>
			<option value="N" <%if(bad_comp.getCar_call_yn().equals("N"))%>selected<%%>>��ȸ��</option>			
                      </select>
                        <%if(bad_comp.getCar_call_yn().equals("")){%>
        		<a href="javascript:doc_sanction_etc('call');">[���ó��]</a>
        		<%}%>
		    </td>
                </tr>                
                <tr> 
                    <td class='title'>���������</td>
                    <td>&nbsp;
                      <%=req_mon%>����
		    </td>
                </tr>                
                <%//if(!bad_comp.getId_cng_req_dt().equals("") || mode.equals("id_cng")){%>
                <tr> 
                    <td class='title'>���Ѻκ����û</td>
                    <td>&nbsp;
                      <input type='text' name='id_cng_req_dt' size='11' value='<%=AddUtil.ChangeDate2(bad_comp.getId_cng_req_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>                        
        		<%if(bad_comp.getId_cng_req_dt().equals("") && mode.equals("id_cng")){%>
        		<%	if(doc.getUser_id1().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) ){%>
        		<a href="javascript:doc_sanction_etc('id_cng_req');">[�����û]</a>        		
        		<%	}%>
        		<%}%>
        		<%if(!bad_comp.getId_cng_req_dt().equals("") && bad_comp.getId_cng_dt().equals("")){%>
        		<%	if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�������",user_id)){%>
        		<a href="javascript:doc_sanction_etc('id_cng');">[����ó��]</a>        		
        		<%	}%>
        		<%}%>
		    </td>
                </tr>        
                <%if(!bad_comp.getId_cng_req_dt().equals("") && !bad_comp.getId_cng_dt().equals("")){%>        
                <tr> 
                    <td class='title'>����ں���</td>
                    <td>&nbsp;
                      <%=AddUtil.ChangeDate2(bad_comp.getId_cng_dt())%> ä�Ǵ���ڷ� ����Ǿ���.
		    </td>
                </tr>                
                <%}%>
                <%//}%>
                <%}%>
           </table>
        </td>
    </tr>        
    <%}%>
    <tr>
        <td class=h>[������ȣ:<%=doc_no%>]</td>
    </tr>				
    <tr>
        <td class=line2></td>
    </tr>	
    <!-- 202008���� ���������� ���� �߰� user_id4 �߰�  -->
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=13% rowspan="2">����</td>
                    <td class=title width=20%>������</td>					
                    <td class=title width=15%>�����</td>
                    <td class=title width=15%>����������</td>
                    <td class=title width=15%>�������</td>
                    <td class=title width=15%>�ѹ�����</td>
                </tr>
                <tr>
                    <td align="center"><%=user_bean.getBr_nm()%></td>				
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if( doc.getUser_dt1().equals("")){%><br><a href="javascript:doc_sanction('1');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt4().equals("")){%><%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����������",user_id)){%><br><a href="javascript:doc_sanction('4')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�������",user_id) ||  doc.getUser_id2().equals(user_id) ){%><br><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%><%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){%><%if(nm_db.getWorkAuthUser("������",user_id) || doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id)){%><br><a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
                </tr>
            </table>
        </td>
    </tr>	
<%if(!mode.equals("view") && !doc.getDoc_step().equals("3")){%> 		
		
<%	if(doc.getUser_id1().equals(user_id) || doc.getUser_id4().equals(user_id) || doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�������",user_id) || nm_db.getWorkAuthUser("�����������",user_id)){%>
    <tr>
	    <td class=h></td>
    </tr>
     <tr>
	    <td class=h><%if(nm_db.getWorkAuthUser("������",user_id)){%>
	    				<%=doc.getDoc_no()%>
	    			<%}%>
	    </td>
    </tr>				
    <tr>
	    <td align="right">
		  <a href="javascript:doc_sanction('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
		  <%	if(!doc.getDoc_step().equals("3") && nm_db.getWorkAuthUser("������",user_id)){%> 	
		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>		  		  
		  <%	}%>	
	    </td>
    </tr>	
<%	}%>
<%}%>	    
	
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
