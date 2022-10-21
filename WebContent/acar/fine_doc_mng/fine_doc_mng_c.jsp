<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	//���·Ḯ��Ʈ
	Vector FineList = FineDocDb.getFineDocLists(doc_id);
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "HEAD", "Y");
	int user_size = users.size();
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "fine1");//���μ���
	String var2 = e_db.getEstiSikVarCase("1", "", "fine2");	//�����	
	String var3 = e_db.getEstiSikVarCase("1", "", "fine_app1");//÷�μ���1
	String var4 = e_db.getEstiSikVarCase("1", "", "fine_app2");//÷�μ���2
	String var5 = e_db.getEstiSikVarCase("1", "", "fine_app3");//÷�μ���3
	String var6 = e_db.getEstiSikVarCase("1", "", "fine_app4");//÷�μ���4
	
	//if(user_id.equals("000058") || user_id.equals("000130") || user_id.equals("000155")) var1 = "000026";//������-�豤��
	//if(user_id.equals("000058") || user_id.equals("000130") || user_id.equals("000155")) var2 = "000058";//��漱
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//���ǽ�û�����
	function ObjectionPrint(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=750, height=800, scrollbars=yes, status=yes");			
	}
	//���ű�� ���� 
	function view_fine_gov(gov_id){
		window.open("../fine_doc_reg/fine_gov_c.jsp?gov_id="+gov_id, "view_FINE_GOV", "left=200, top=200, width=560, height=250, scrollbars=yes");
	}
	//����ϱ�(FineDocPrint(1~5) ����)
	function FineDocPrint(num){
		var fm = document.form1;
		var SUMWIN = "";
		var start_num 	= 0;
		var end_num 	= 0;
		if(fm.doc_print_st.value == '' && toInt(fm.d_start_num.value) >0){
			start_num 		= toInt(fm.d_start_num.value);
			end_num 		= toInt(fm.d_end_num.value);
		}
		if(num=='1'){ num="";}
		SUMWIN="fine_doc"+num+"_print.jsp?doc_id=<%=doc_id%>&start_num="+start_num+"&end_num="+end_num;
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=800, scrollbars=yes, status=yes");			
	}
	//����ϱ�
	<%-- function FineDocPrint(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="fine_doc_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=800, scrollbars=yes, status=yes");			
	} --%>
	//����ϱ�
	function FineDoc2Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="fine_doc2_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=800, scrollbars=yes, status=yes");			
	}	
	//����ϱ�
	function FineDoc3Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="fine_doc3_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=800, scrollbars=yes, status=yes");			
	}	
	//����ϱ�
	function FineDoc4Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="fine_doc4_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=800, scrollbars=yes, status=yes");			
	}	
	//����ϱ�
	function FineDoc5Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="fine_doc5_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=800, scrollbars=yes, status=yes");			
	}			
	//��Ϻ���
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "fine_doc_mng_frame.jsp";
		fm.submit();
	}			
	//�����ϱ�
	function fine_update(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "fine_doc_mng_u.jsp";
		fm.submit();
	}	
	
	//�����ϱ�
	function fine_upd(){
		window.open("fine_doc_mng_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>", "REG_FINE_GOV", "left=100, top=200, width=860, height=400, scrollbars=yes");
	}
		
	//����Ʈ�����ϱ�
	function list_save(doc_id, car_mng_id, seq_no){
		window.open("fine_doc_list_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&car_mng_id="+car_mng_id+"&seq_no="+seq_no, "REG_FINE_LIST", "left=100, top=200, width=1160, height=300, scrollbars=yes");
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			

	//�˾������� ����-��ĵ����
	function MM_openBrWindow2(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/fine/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//����: ��ĵ ����
	function view_map(map_path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}	
	//��ĵ���� ����
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=650, scrollbars=yes");		
	}			
	
	//����ý��� ��༭
	function view_scan_res(c_id, s_cd){
		window.open("/acar/rent_mng/res_rent_u_print.jsp?c_id="+c_id+"&s_cd="+s_cd+"&mode=fine_doc", "VIEW_SCAN_RES", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}

	//���ǿ��� ��༭
	function view_scan_res2(c_id, seq_no, m_id, l_cd, rent_st){
		window.open("/fms2/lc_rent/lc_im_doc_print.jsp?car_mng_id="+c_id+"&seq_no="+seq_no+"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&rent_st="+rent_st+"&doc_dt=<%=FineDocBn.getDoc_dt()%>&mode=fine_doc", "VIEW_SCAN_RES2", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}
	
	//�˾������� ����
	function ScanOpen(theURL,file_type) { //v2.0
		
		if(file_type == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/fine/"+theURL+".pdf";
		}else{			
			theURL = "https://fms3.amazoncar.co.kr/data/fine/"+theURL+""+file_type;		
		}
		if(file_type == 'jpg'){
			window.open('/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL,'popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			window.open(theURL,'popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
	}	
	
	//������� ����
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	

	//���������μ�
	function select_out2(){
		var fm = document.form1;
		var start_num 	= 0;
		var end_num 	= 0;
		
		if(fm.doc_print_st.value == '' && toInt(fm.d_start_num.value) >0){
			start_num 		= toInt(fm.d_start_num.value);
			end_num 		= toInt(fm.d_end_num.value);
		}else{ 
			if(fm.doc_print_st.value == ''){ alert('�����μ� ������ �����Ͻʽÿ�.'); return; }
			var select_nums = fm.doc_print_st.value.split("~");
			start_num 		= toInt(select_nums[0]);
			end_num 		= toInt(select_nums[1]);
		}		
		
		//�������� �� �ǿ�
		//fm.start_num.value 	= start_num;
		//fm.end_num.value 	= end_num;		
		//fm.target = "_blank";
		//fm.action = "fine_doc_print_select6.jsp?";
		//fm.submit();
		
		//�������� �� �˾���
		var url = "/acar/fine_doc_mng/fine_doc_print_select6.jsp?user_id=<%=user_id%>&doc_id=<%=doc_id%>&start_num="+start_num+"&end_num="+end_num;
		window.open(url, "PRINT", "left=100, top=100, width=1100, height=800, scrollbars=yes");
		
		//�� �Ǿ� ���� �˾�
		<%-- for(var i=start_num; i<=end_num; i++){
			var url = "/acar/fine_doc_mng/fine_doc_print_select6.jsp?user_id=<%=user_id%>&doc_id=<%=doc_id%>&start_num="+i+"&end_num="+i;
			window.open(url, "PRINT_"+i , "left=100, top=100, width=1100, height=800, scrollbars=yes");
		} --%>
	}
	
	function h_print(idx){
		var fm = document.form1;
		fm.start_num.value = idx;
		fm.end_num.value = idx;
		//fm.target = "i_no";
		fm.target = "_blank";
		fm.action = "fine_doc_print_select6.jsp";
		fm.submit();
	}
	
	function h_print_pop(idx){
		var url = "/acar/fine_doc_mng/fine_doc_print_select6.jsp?user_id=<%=user_id%>&doc_id=<%=doc_id%>&start_num="+idx+"&end_num="+idx;
		window.open(url, "PRINT_"+idx, "left=100, top=100, width=1100, height=800, scrollbars=yes");
		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' id='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' id='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='start_num' id='start_num' value=''>
<input type='hidden' name='end_num' id='end_num' value=''>



<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > <span class=style5>���ǽ�û��������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>    
        <td align="right" >
	  	 	  <a href="javascript:fine_upd();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a>&nbsp;
			  <a href="javascript:go_list();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif"  align="absmiddle" border="0"></a>
		 </td>
			  
         
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line" width="100%"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=13%>������ȣ</td>
                    <td width=87%>&nbsp;<%=FineDocBn.getDoc_id()%></td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp;<%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;<a href="javascript:view_fine_gov('<%=FineGovBn.getGov_id()%>');" onMouseOver="window.status=''; return true"><%=FineGovBn.getGov_nm()%></a></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;<%=FineDocBn.getMng_dept()%> 
        			<%if(!FineDocBn.getMng_nm().equals("")){%>						
        			(����� : <%=FineDocBn.getMng_nm()%> <%=FineDocBn.getMng_pos()%>) 
        			<%}%>						
        			</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;���α�������� ���·� �ΰ� ó�п� ���� �ǰ� ���� (���·� �����ǹ��� ���� ��û)</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;�� 
                    <%=FineDocBn.getGov_st()%>
                    �� ������ ������ ����մϴ�. </td>
                </tr>		  
                <tr> 
                    <td class='title'>÷��</td>
                    <td>
        			<input type="checkbox" name="app_doc1" value="Y" disabled <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var3%><br>
        			<input type="checkbox" name="app_doc2" value="Y" disabled <%if(FineDocBn.getApp_doc2().equals("Y"))%>checked<%%>><%=var4%><br>
        			<input type="checkbox" name="app_doc3" value="Y" disabled <%if(FineDocBn.getApp_doc3().equals("Y"))%>checked<%%>><%=var5%><br>
        			<input type="checkbox" name="app_doc4" value="Y" disabled <%if(FineDocBn.getApp_doc4().equals("Y"))%>checked<%%>><%=var6%>
        			</td>
                </tr>	
                <tr> 
                    <td class='title'>����ȣ</td>
                    <td>&nbsp;<%=FineDocBn.getPost_num()%></td>
                </tr>	  		  
            </table>
        </td>
    </tr>
    <tr>     
        <td></td>    
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr>     
        <td class=line2></td>    
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width=13% class='title'>���μ���</td>
                    <td width=37%><select name='h_mng_id' disabled>
                        <option value="">����</option>
                        <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getH_mng_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                        </select></td>
                    <td  width=13% class='title'>�����</td>
                    <td width=37%><select name='b_mng_id' disabled>
                        <option value="">����</option>
                        <%	if(user_size2 > 0){
            						for (int i = 0 ; i < user_size2 ; i++){
            							Hashtable user = (Hashtable)users2.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getB_mng_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                        </select></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr> 
        <td align="right">
    	  
    	  <%if(FineDocBn.getPrint_dt().equals("")){%>
    	  <!-- <a href="javascript:FineDocPrint();"><img src=/acar/images/center/button_print_gm.gif align=absmiddle border=0></a>&nbsp;&nbsp; -->
    	  <a href="javascript:FineDocPrint('1');"><img src=/acar/images/center/button_print_gm.gif align=absmiddle border=0></a>&nbsp;&nbsp;
    	  <%}else{%>
    	  <%-- <img src=/acar/images/center/arrow_printd.gif align=absmiddle> : <a href="javascript:FineDocPrint();"><%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%> (<%=c_db.getNameById(FineDocBn.getPrint_id(), "USER")%>)</a>&nbsp;&nbsp; --%>
    	  <img src=/acar/images/center/arrow_printd.gif align=absmiddle> : <a href="javascript:FineDocPrint('1');"><%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%> (<%=c_db.getNameById(FineDocBn.getPrint_id(), "USER")%>)</a>&nbsp;&nbsp;
    	  <%}%>	  
    	  <!-- <a href="javascript:FineDoc2Print();">[��⹰���������ݰ���]</a>&nbsp;&nbsp;
		  <a href="javascript:FineDoc3Print();">[����������ݰ���]</a>&nbsp;&nbsp;
		  <a href="javascript:FineDoc4Print();">[��������������������ݰ���]</a>&nbsp;&nbsp;
		  <a href="javascript:FineDoc5Print();">[���ᵵ�ι����ݰ���]</a>&nbsp;&nbsp; -->
		  <a href="javascript:FineDocPrint('2');">[��⹰���������ݰ���]</a>&nbsp;&nbsp;
		  <a href="javascript:FineDocPrint('3');">[����������ݰ���]</a>&nbsp;&nbsp;
		  <a href="javascript:FineDocPrint('4');">[��������������������ݰ���]</a>&nbsp;&nbsp;
		  <a href="javascript:FineDocPrint('5');">[���ᵵ�ι����ݰ���]</a>&nbsp;&nbsp;
		  <!-- <a href="javascript:FineDocPrint('6');">[����˻�Ⱓ�������]</a>&nbsp;&nbsp;�߰�(20181123) -->
	    </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���·Ḯ��Ʈ</span> 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		
		<select name='doc_print_st'> 
		  <option value="">����</option>
		<%	int max_num = 20;
			for(int i=0; i<FineList.size(); i+=max_num){
				int start_num 	= i+1;
				int end_num 	= i+max_num;
				if(end_num>FineList.size()) end_num = FineList.size();  %>
		  <option value="<%=start_num%>~<%=end_num%>"><%=start_num%>~<%=end_num%></option>
		<%	}%>	
		</select>
		&nbsp;	
		��Ÿ���� : 
		<input type="text" name="d_start_num" size="2" class="text" value="">~<input type="text" name="d_end_num" size="2" class="text" value="">
		&nbsp;
		<a href="javascript:select_out2();" title="��ĵ���� �����μ�"><img src="/acar/images/center/button_print_all.gif" align="absmiddle" border="0"></a>
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="4%" rowspan="2">����</td>
                    <td width='14%' class='title' rowspan="2">��������ȣ</td>
                    <td width='10%' class='title' rowspan="2">������ȣ</td>
                    <td colspan="4" class='title'>������</td>
                    <td colspan="3" class='title'>��ĵ</td>
                </tr>
                <tr> 
                    <td width='22%' class='title'>��ȣ/����</td>
                    <td width='10%' class='title'>�������</td>
                    <td width='10%' class='title'>����ڵ�Ϲ�ȣ</td>
                    <td width='14%' class='title'>�Ӵ�Ⱓ</td>
        			<td width='6%' class='title'>������</td>
        			<td width='5%' class='title'>���</td>
        			<td width='5%' class='title'>�ܱ�</td>					
                </tr>
              <% if(FineList.size()>0){
    				for(int i=0; i<FineList.size(); i++){ 
    					FineDocListBn = (FineDocListBean)FineList.elementAt(i); %>		  
                <tr align="center">		    
                    <td><a href="javascript:h_print_pop('<%=i+1%>')" onMouseOver="window.status=''; return true"><%=i+1%></a></td>
                    <%-- <td><a class=index1 href="javascript:MM_openBrWindow('../fine_doc_reg/fine_c.jsp?m_id=<%=FineDocListBn.getRent_mng_id()%>&l_cd=<%=FineDocListBn.getRent_l_cd()%>&c_id=<%=FineDocListBn.getCar_mng_id()%>&seq_no=<%=FineDocListBn.getSeq_no()%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><%=FineDocListBn.getPaid_no()%></a></td> --%>
                    <td>
                    	<a class=index1 href="javascript:MM_openBrWindow('../fine_doc_reg/fine_c.jsp?m_id=<%=FineDocListBn.getRent_mng_id()%>&l_cd=<%=FineDocListBn.getRent_l_cd()%>&c_id=<%=FineDocListBn.getCar_mng_id()%>&seq_no=<%=FineDocListBn.getSeq_no()%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><%=FineDocListBn.getPaid_no()%></a>
                    	<%-- <a class="button" href="javascript:h_print('<%=i+1%>')" onMouseOver="window.status=''; return true">���</a> --%>
                    	<%-- <img src="/acar/images/center/button_in_print.gif" onclick="javascript:h_print_pop('<%=i+1%>')" onMouseOver="window.status=''; return true"> --%>
                    </td>			
                    <td><%=FineDocListBn.getCar_no()%></td>
                    <td><a href="javascript:view_client('<%=FineDocListBn.getRent_mng_id()%>','<%=FineDocListBn.getRent_l_cd()%>','')"><%=FineDocListBn.getFirm_nm()%></a> <font color=red><%=FineDocListBn.getVar1()%></font></span></td>
                    <td><%=AddUtil.ChangeSsn(FineDocListBn.getSsn())%></td>
                    <td><%=AddUtil.ChangeEnt_no(FineDocListBn.getEnp_no())%></td>
                    <td><a href="javascript:list_save('<%=FineDocListBn.getDoc_id()%>','<%=FineDocListBn.getCar_mng_id()%>','<%=FineDocListBn.getSeq_no()%>')"><%=FineDocListBn.getRent_start_dt()%> ~ <%=FineDocListBn.getRent_end_dt()%></a></td>
        			<td>
        			  <%if(!FineDocListBn.getFile_name().equals("")){%>
					  <!--<a href="javascript:MM_openBrWindow2('<%=FineDocListBn.getFile_name()%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a><br>-->
					  <a href="javascript:ScanOpen('<%=FineDocListBn.getFile_name()%>','<%=FineDocListBn.getFile_type()%>')"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
					  <%=FineDocListBn.getFile_name()%>//<%=FineDocListBn.getFile_type()%>			  
        			  <%}else{%>
        			  <a href="/acar/fine_mng/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=FineDocListBn.getRent_mng_id()%>&l_cd=<%=FineDocListBn.getRent_l_cd()%>&c_id=<%=FineDocListBn.getCar_mng_id()%>&seq_no=<%=FineDocListBn.getSeq_no()%>" target="_blank"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
        			  <%}%>			  
        			</td>
                    <td>
        			<%if(FineDocListBn.getCar_st().equals("2")){//�Ƹ���ī ���������̸�%>
        				������
        			<%}else{%>
        				<a href="javascript:view_scan('<%=FineDocListBn.getRent_mng_id()%>','<%=FineDocListBn.getRent_l_cd()%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
        			<%}%>		
        			</td>
                    <td>
        			<%if(!FineDocListBn.getRent_s_cd().equals("")){//�Ƹ���ī ���������̸�%>
        				<a href="javascript:view_scan_res('<%=FineDocListBn.getCar_mng_id()%>','<%=FineDocListBn.getRent_s_cd()%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
        			<%}%>
					<%if(FineDocListBn.getFee_st().equals("����")){//�Ƹ���ī ���������̸�%>
        				<a href="javascript:view_scan_res2('<%=FineDocListBn.getCar_mng_id()%>','<%=FineDocListBn.getSeq_no()%>','<%=FineDocListBn.getRent_mng_id()%>','<%=FineDocListBn.getRent_l_cd()%>','<%=FineDocListBn.getRent_st()%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
        			<%}%>
        			</td>
                </tr>
              <% 	}
    			} %>
            </table>
        </td> 
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
