<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.cont.*,  acar.client.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
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
	
	String email = "";
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	email = FineDocBn.getRemarks();
	
	//�̼�ä�� ����Ʈ
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);
	

	//�ŷ�ó
	ClientBean client = al_db.getClient(gov_id);
	
	if ( email.equals("") ) {
	
		email = client.getCon_agnt_email();
	
	}
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	int size = 0;
	String s_know_how_id = request.getParameter("know_how_id")==null?"":request.getParameter("know_how_id");
	String content_code = "FINE_DOC";
	String content_seq  = doc_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	

	for(int j=0; j< attach_vt.size(); j++){
		Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
		
		if((content_seq).equals(aht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(aht.get("FILE_NAME"));
			file_type1 = String.valueOf(aht.get("FILE_TYPE"));
			seq1 = String.valueOf(aht.get("SEQ"));
			
		}
	}
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

	//����ϱ�
	function FineDocPrint(){
		var fm = document.form1;
		var SUBWIN="fine_doc_print.jsp?doc_id=<%=doc_id%>";	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	//��Ϻ���
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "settle_doc_mng_frame.jsp";
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
		window.open("settle_doc_mng_u.jsp?doc_id=<%=doc_id%>&gov_id=<%=gov_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>", "REG_FINE_GOV", "left=100, top=200, width=860, height=430, scrollbars=yes");
	}
		
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			

	//����: ��ĵ ����
	function view_map(map_path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}	
	//��ĵ���� ����
	function view_scan(m_id, l_cd){
		window.open("/acar/car_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}			
	
	function fine_del(){
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.target = "d_content";
		fm.action = "settle_doc_mng_d_a.jsp";
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
	
	//�ߵ���������  ����
	function view_settle(m_id, l_cd){
		window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
	}	

		//��ĵ���
function scan_reg(){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&doc_id=<%=doc_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
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
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='gov_nm' value='<%=FineDocBn.getGov_nm()%>'>
<input type='hidden' name='doc_title' value='<%=FineDocBn.getTitle()%>'>


<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ä�ǰ��� > <span class=style5>�ְ������</span></span></td>
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
	  <%if(auth_rw.equals("6")){%>
	  <a href="javascript:fine_del();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
	  <a href="javascript:fine_upd();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;<%}%>
	  <a href="javascript:go_list();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width=12%>������ȣ</td>
            <td colspan=3>&nbsp;<%=FineDocBn.getDoc_id()%></td>
          </tr>
          <tr> 
            <td class='title'>��������</td>
            <td colspan=3>&nbsp;<%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></td>
          </tr>
          <tr> 
            <td rowspan="2" class='title'>����</td>
            <td colspan=3 >&nbsp;<%=FineDocBn.getGov_nm()%></td>
          </tr>
          <tr>
            <td colspan=4>&nbsp;<%=FineDocBn.getGov_zip()%>&nbsp;<%=FineDocBn.getGov_addr()%></td>
          </tr>
          <tr> 
            <td class='title'>����</td>
            <td colspan=3>&nbsp;<%=FineDocBn.getMng_dept()%> 
			<%if(!FineDocBn.getMng_nm().equals("")){%>						
			(����� : <%=FineDocBn.getMng_nm()%> <%=FineDocBn.getMng_pos()%>) 
			<%}%>						
			</td>
          </tr>
          <tr> 
            <td class='title'>����</td>
            <td colspan=3>&nbsp;<%=FineDocBn.getTitle()%></td>
          </tr>          
          <tr> 
            <td class='title'>�����Ⱓ</td>
            <td colspan=3 >&nbsp;<%=AddUtil.ChangeDate2(FineDocBn.getEnd_dt())%></td>
          </tr>		
          <tr> 
            <td class='title'>��ĵ</td>
            <td colspan=3>&nbsp;
				<%if(!file_name1.equals("")){%>
					<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
						<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='����' ><%=file_name1%></a>
					<%}else{%>
						<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
					<%}%>
				 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
				<%}else{%>
					<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
				<%}%>
          </tr>		  		  
		  <tr> 
            <td class='title'>�ȳ�����</td>
            <td colspan=3>&nbsp;�����ּ� : <input type='text' name='email' size='30' value='<%=email%>' class='text'>&nbsp;
            <% if ( FineDocBn.getTitle().equals("������� �� �����ְ�") || FineDocBn.getTitle().equals("������� �� �����ݳ� �뺸") || FineDocBn.getTitle().equals("�����뺸 �� ��������� ���԰���")) { %>
            <a href="javascript:doc_email()"><img src="/acar/images/center/button_in_s.gif" align="absmiddle" border="0"></a>
            <% } %>
            </td>
          </tr>	  
          <tr>
           <td class='title'>���</td>
           <td>&nbsp; 
			  <select name="f_result" >
			    <option value="" <% if(FineDocBn.getF_result().equals("")){%>selected<%}%>>--����--</option>
                <option value="1" <% if(FineDocBn.getF_result().equals("1")){%>selected<%}%>>�ݼ�</option>
				<option value="2" <% if(FineDocBn.getF_result().equals("2")){%>selected<%}%>>����</option>
              
              </select>
		    </td>
		    <td class='title'>����</td>
            <td>&nbsp; 
			  <select name="f_reason" >
			    <option value="" <% if(FineDocBn.getF_reason().equals("")){%>selected<%}%>>--����--</option>
                <option value="1" <% if(FineDocBn.getF_reason().equals("1")){%>selected<%}%>>�̻簨</option>
                <option value="2" <% if(FineDocBn.getF_reason().equals("2")){%>selected<%}%>>�����κ���</option>
                <option value="3" <% if(FineDocBn.getF_reason().equals("3")){%>selected<%}%>>�󹮺���</option>
                <option value="4" <% if(FineDocBn.getF_reason().equals("4")){%>selected<%}%>>�������</option>
                <option value="5" <% if(FineDocBn.getF_reason().equals("5")){%>selected<%}%>>�ּҺҸ�</option>
                <option value="6" <% if(FineDocBn.getF_reason().equals("6")){%>selected<%}%>>�����κҸ�</option>              
              
              </select>
		    </td>
         
          </tr>	  		 
           
          		  
        </table>
      </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̼�ä�Ǹ���Ʈ</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width="4%" class='title'>����</td>
            <td width='12%' class='title'>����ȣ</td>
            <td width='12%' class='title'>������ȣ</td>
            <td width="12%" class='title'>������</td>
            <td width="12%" class='title'>�뿩��</td>
            <td width="10%" class='title'>���·�</td>
            <td width="10%" class='title'>��å��</td>
            <td width='12%' class='title'>�ߵ����������</td>
            <td width='10%' class='title'>�հ�</td>
            <td width='6%' class='title'>����</td>
          </tr>
          <% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					FineDocListBn = (FineDocListBean)FineList.elementAt(i); 
														
					//���⺻����
				    ContBaseBean base = a_db.getCont( FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd() );
	
					%>		  
          <tr align="center"> 
            <td><%=i+1%></td>
            <td><%=FineDocListBn.getRent_l_cd()%></td>			
            <td><%=FineDocListBn.getCar_no()%></td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt1())%><br> (<%=Util.parseDecimal(FineDocListBn.getVar1())%> )</td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt2())%><br> (<%=Util.parseDecimal(FineDocListBn.getAmt7())%> )</td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt3())%></td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt4())%></td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt5())%></td>
            <td><%=Util.parseDecimal(FineDocListBn.getAmt6())%></td>
            <td>
             <%	if(!base.getUse_yn().equals("N")){%>            
        	          <a href="javascript:view_settle('<%=FineDocListBn.getRent_mng_id()%>','<%=FineDocListBn.getRent_l_cd()%>');" class="btn" title='�����ϱ�'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>
        	
			 <%	}%>			 
		    </td>
          </tr>
          <% 	}
			} %>
        </table>
      </td>
      <td>&nbsp;</td>	  
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
