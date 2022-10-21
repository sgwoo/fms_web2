<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

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
	
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String serv_dt = FineDocDb.getServ_dt(doc_id);
	
	
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
		fm.action = "fine_doc3_mng_u.jsp";
		fm.submit();
	}	
	
	//�����ϱ�
	function fine_upd(){
		window.open("settle_doc3_mng_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>", "REG_FINE_GOV", "left=100, top=200, width=860, height=330, scrollbars=yes");
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
	
		//����	
	function ToSue(){
		var fm = document.form1;
		var SUMWIN = "";		
		SUMWIN="myaccid_sue_doc_print.jsp?doc_id=<%=doc_id%>";		
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	
		//���	
	function ToTDoc(){
		var fm = document.form1;
		var SUMWIN = "";		
		SUMWIN="myaccid_doc_tot_print.jsp?doc_id=<%=doc_id%>";		
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	//�ʿ伭��
	function DocSelect(m_id, l_cd, c_id, accid_id,seq_no){
		var fm = document.form1;
		var SUBWIN="/acar/accid_mng/myaccid_reqdoc_select.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&seq_no="+seq_no;			
		window.open(SUBWIN, "DocSelect", "left=50, top=50, width=950, height=600, scrollbars=yes, status=yes");	
	}
		
	function view_excel(){
		var fm = document.form1;	
		
		fm.target = "_blank";
		fm.action = "settle_doc_excel.jsp";
		fm.submit();	
	}
	
	function update_serv_dt(){
		var fm = document.form1;	
		window.open("/fms2/credit/settle_doc_mng3_serv_u_a.jsp?doc_id=<%=AddUtil.replace(doc_id,"����","")%>&serv_dt="+fm.serv_dt.value, "UPDATE_SERV_DT", "left=100, top=200, width=860, height=330, scrollbars=yes");
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
            <td colspan=4>&nbsp;<%=FineDocBn.getGov_addr()%></td>
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
            <td colspan=3>&nbsp;<a href="https://fms3.amazoncar.co.kr/data/stop_doc/<%=FineDocBn.getFilename()%>" target="_blank"><%=FineDocBn.getFilename()%></a></td>
          </tr>		  		  
	
          <tr>
           <td class='title'>���</td>
           <td>&nbsp; 
			  <select name="f_result" >
			    <option value="" <% if(FineDocBn.getF_result().equals("")){%>selected<%}%>>--����--</option>
                <option value="1" <% if(FineDocBn.getF_result().equals("1")){%>selected<%}%>>�ݼ�</option>
              
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
          
              <!--�������-->
	 <tr>
           <td class='title'>������(����)</td>
           <td>&nbsp; <input type="text" name="amt1"  value="<%=AddUtil.parseDecimal(FineDocBn.getAmt1())%>" size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> �� </td>			
	  <td class='title'>�۴޷�(����)</td>
            <td>&nbsp; <input type="text" name="amt2"  value="<%=AddUtil.parseDecimal(FineDocBn.getAmt2())%>"size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> �� </td>			
		        
          </tr>	  	
          		  
        </table>
      </td>
    </tr>
    
    <% if ( gubun1.equals("2")) { %>
     <tr> 
        <td align="right" colspan=2>        	
				<a href="javascript:ToTDoc();">���</a>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:ToSue();">����</a> 
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�������� &nbsp;:&nbsp;<input type="text" name="serv_dt"  value="<%=AddUtil.ChangeDate2(serv_dt)%>"size='15' >&nbsp;&nbsp; <a href="javascript:update_serv_dt();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_reg.gif align=absmiddle></a> &nbsp;&nbsp;&nbsp;
        </td>
    </tr>
   <% } %> 
    <tr>
        <td></td>
    </tr>
    <tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��/������ ����Ʈ</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:view_excel();">[����]</a></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
         <tr> 
            <td class='title' width="4%" >����</td>
            <td class='title' width="8%">������ȣ</td>
            <td class='title' width="8%">��ȣ</td>
            <td class='title' width="8%">����ó</td>
            <td class='title' width="6%">�����<br>������ </td>
			<td class='title' width="10%">�����ȣ</td>
            <td class='title' width="8%">û������</td>						
            <td class='title' width="7%">û����</td>									
            <td class='title' width="8%">�Ա�����</td>												
            <td class='title' width="7%">�Աݾ�</td>
            <td class='title' width="7%">����</td>
            <td class='title' width="7%">����</td>
            <td class='title' width="8%">��</td>
            <td width='4%' class='title'>����</td>
          </tr>
 <% 	Vector vt = FineDocDb.getMyAccidDocLists_2(doc_id);
			int vt_size = vt.size();
           if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					Hashtable ht = (Hashtable)vt.elementAt(i);
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
					%>	         

            <tr align="center"> 
            <td><%=i+1%><%if(nm_db.getWorkAuthUser("������",user_id)||nm_db.getWorkAuthUser("���ó��",user_id)){%>	&nbsp;<%if(!ht.get("FILENAME").equals("")){%>Y<%}%><%}%></td>
            <td><%=ht.get("OUR_CAR_NO")%></td>			
            <td><%=ht.get("FIRM_NM")%></td>
            <td><%=ht.get("INS_TEL")%></td>
            <td><%=ht.get("ACCID_ST")%>[<font color="red"><%=ht.get("OT_FAULT_PER")%></font>]</td>
			<td><%=ht.get("INS_NUM")%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT1"))%>&nbsp;</td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT2"))%>&nbsp;</td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT3"))%>&nbsp;</td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT4"))%>&nbsp;</td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT5"))%>&nbsp;</td>
            <td>&nbsp;<a href="javascript:DocSelect('<%=String.valueOf(ht.get("RENT_MNG_ID"))%>', '<%=String.valueOf(ht.get("RENT_L_CD"))%>', '<%=String.valueOf(ht.get("CAR_MNG_ID"))%>','<%=String.valueOf(ht.get("ACCID_ID"))%>','<%=String.valueOf(ht.get("SEQ_NO"))%>')" title='û�������ϰ��μ�'><img src="/acar/images/center/button_in_print.gif" align="absmiddle" border="0"></a>
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
<script language='javascript'>
<!--
function del_fineone(doc_id, m_id, l_cd){
	
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.target = "_blank";
		fm.action = "settle_doc_mng_d_a.jsp?m_id="+m_id+"&l_cd="+l_cd";
		fm.submit();
	}
	-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
