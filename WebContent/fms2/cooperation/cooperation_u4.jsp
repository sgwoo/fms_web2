<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.common.*, acar.client.*, acar.car_register.*, acar.cooperation.* "%>
<%@ page import="acar.accid.*, acar.res_search.*, acar.cont.*, acar.short_fee_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" 	class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" 	class="acar.fee.AddFeeDatabase"	/>
<jsp:useBean id="al_db" scope="page" 	class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String seq_no 	= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");//�������Ϸù�ȣ
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");//��������ȣ
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	
	String bus_id2 	= "";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	CooperationDatabase co_db 	= CooperationDatabase.getInstance();
	
	Hashtable con = a_db.getContCase(l_cd);
	
	m_id = String.valueOf(con.get("RENT_MNG_ID"));
	c_id = String.valueOf(con.get("CAR_MNG_ID"));
	
	String rent_st = String.valueOf(con.get("RENT_ST"));
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(String.valueOf(cont.get("CLIENT_ID")));
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size = af_db.getMaxRentSt(m_id, l_cd);
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
		
	int count = 0;
  	String file_st = "";
    String file_rent_st = "";
	String contentNm ="";
	
	String content_code = "LC_SCAN";
	String content_seq  = m_id+""+l_cd;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
			
	content_code = "FINE_DOC";
	
	Vector conProof = co_db.getContProofList(l_cd);		
	int conProof_size = conProof.size();
	
	content_code = "OFF_DOC";
	content_seq  = "docs1";
	
	Vector amazon_attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int amazon_attach_vt_size = amazon_attach_vt.size();	
	

	SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss", Locale.KOREA );
	Date currentTime = new Date ();
	String mTime = mSimpleDateFormat.format ( currentTime );
	
	
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	//������ȣ �̷�
	CarHisBean ch_r [] = crd.getCarHisAll(c_id);
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script src='/include/common.js'></script>
<script>
function addr_ask_appl_reg(){
	var fm = document.form1;	
	 window.open("" ,"form1", 
     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
	fm.action = "addr_ask_appl_reg.jsp";
	//fm.target = "_blank";
	fm.target = "form1";
	fm.method="post";
	fm.submit();	
}	
function doc_cert_print(){
	var fm = document.form1;	
	 window.open("" ,"form1", 
     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
	fm.action = "/fms2/insa_card/doc_cert_stamp.jsp?user_id="+'<%=ck_acar_id%>';
	//fm.target = "_blank";
	fm.target = "form1";
	fm.method="post";
	fm.submit();	
}	
function war_cert_print(){
	var fm = document.form1;	
	 window.open("" ,"form1", 
     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
	fm.action = "/fms2/insa_card/war_cert.jsp?user_id="+'<%=ck_acar_id%>';
	//fm.target = "_blank";
	fm.target = "form1";
	fm.method="post";
	fm.submit();	
}	
function fee_scd_print(m_id, l_cd){
	var fm = document.form1;	
	 window.open("" ,"form1", 
     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
	fm.action = "/fms2/con_fee/fee_scd_print_ext.jsp?m_id="+m_id+"&l_cd="+l_cd;
	//fm.target = "_blank";
	fm.target = "form1";
	fm.method="post";
	fm.submit();	
}	
//��ü����
function AllSelect(){
	var fm = document.form1;
	var len = fm.ch_cd.length;
	var cnt = 0;
	var idnum ="";
	var allChk = fm.ch_all;
	 for(var i=0; i<len; i++){
		var ck = fm.ch_cd[i];
		 if(allChk.checked == false){
			ck.checked = false;
		}else{
			ck.checked = true;
		} 
	} 
}	

//�������
function Accid_ReqDoc_Print(){
	var fm = document.form1;	
	var len=fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck=fm.elements[i];		
		if(ck.name == "ch_cd"){		
			if(ck.checked == true){
				cnt++;
				idnum=ck.value;
			}
		}
	}			
	if(cnt == 0){
	 	alert("�μ��� ������ �����ϼ���.");
		return;
	}	
	
	if(confirm('û�������� ���� �μ��Ͻðڽ��ϱ�?')){
		 window.open("" ,"form1", 
	     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
		//fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/cooperation_u3_print.jsp";
		fm.action = "cooperation_u4_print.jsp";
		//fm.target = "_blank";
		fm.target = "form1";
		fm.method="post";
		fm.submit();	
	}
}		
</script>
</head>
<body>
<form action="" name="form1">
<input type="hidden" name="rent_l_cd" value="<%=l_cd%>">
<input type="hidden" name="rent_mng_id" value="<%=m_id%>">
<input type="hidden" name="rent_st" value="<%=rent_st%>">
<input type="hidden" name="seq" value="<%=seq%>">
<table border="0" cellspacing="0" cellpadding="0" width=670>
	<tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ä�ǰ��� > <span class=style1>����������ɿ�û ><span class=style5>��ĵ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
     <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����ȣ</td>
                    <td width='35%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>��ȣ</td>
                    <td width='35%'>&nbsp;<%=client.getFirm_nm()%>&nbsp;<%=cont.get("CLIENT_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=cont.get("CAR_NO")%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                </tr>
				<%for(int i=1; i<=fee_size; i++){
						ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));
//						ContCarBean fee_etcs = a_db.getContFeeEtc(m_id, l_cd, Integer.toString(i));%>
                <tr>
					<td class='title'>�뿩�Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>				
                    <td class='title'>�뿩����</td>
                    <td>&nbsp;<%=fees.getCon_mon()%>����<%if(i>1){%>(����)<%}%></td>
                    
                </tr>						
				<%}%>
                <tr> 
                    <td class='title'>�����ּ�</td>
                    <td colspan=''>&nbsp;<%=client.getHo_zip()%>&nbsp;<%= client.getHo_addr()%>&nbsp;<%=client.getClient_nm()%></td>
					<td class='title'>��ȭ��ȣ</td>
                    <td colspan=''>&nbsp;<%if(!client.getO_tel().equals("")){%><%=client.getO_tel()%><%}else{%><%=client.getM_tel() %><%} %></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		    <td class="title" width='3%'></td>
		    <td class='title' width='3%'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td class="title" width='8%'>���</td>
		    <td class="title" width='29%'>����</td>                    
		    <td class="title" width='30%'>���Ϻ���</td>
		    <td class="title" width='20%'>�����</td>
		</tr>
		
		 <% if(amazon_attach_vt_size > 0){
			for (int j = 0 ; j < amazon_attach_vt_size ; j++){
				Hashtable ht = (Hashtable)amazon_attach_vt.elementAt(j);
				if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).equals("docs1")){
					/* 	rent_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(19,20);
						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 	 */					
						contentNm =  String.valueOf(ht.get("FILE_NAME"));
						contentNm = contentNm.substring(0,contentNm.lastIndexOf("."));
						if(!contentNm.equals("") && contentNm.contains("���ε��ε")) contentNm ="�Ƹ���ī ���ε��ε";
						else if(!contentNm.equals("") && contentNm.contains("����ڵ����")) contentNm ="�Ƹ���ī ����ڵ����";
						else if(!contentNm.equals("") && contentNm.contains("�����ΰ�����")) contentNm ="�Ƹ���ī �����ΰ�����";
				}
	
			if(!contentNm.equals("") && !contentNm.contains("�����ΰ�����") ){
	%>                
		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     		<%if(!String.valueOf(ht.get("FILE_TYPE")).equals("application/pdf")){ %>
     			<input type="checkbox" name="ch_cd" value="<%=String.valueOf(ht.get("SEQ"))%>">
     		<%} %>
     		</td>
			<td align="center">�Ƹ���ī</td>		
     		<td align="center"><%=contentNm%></td>
			<td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><img src='/acar/images/center/button_in_print.gif' border=0></a></td>
			<td align="center"><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
		</tr>
		<%
			count++;
			}		
		}
		
	  }
	  %>
  		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     			<!-- <input type="checkbox" name="ch_cd" value="doc3"> -->
     		</td>
		    
			<td align="center">�Ƹ���ī</td>
     		<td align="center">�뿩�ὺ����ǥ</td>
			<td align="center">
				<a href="javascript:fee_scd_print('<%=m_id%>','<%=l_cd%>')"><img src='/acar/images/center/button_in_print.gif' border=0></a>
			<!-- 	&nbsp;
				<a href="javascript:addr_ask_appl_reg()"><img src='/acar/images/center/button_in_reg.gif' border=0></a> -->
			</td>
			<td align="center"><div><%=mTime.substring(0,10)%></div><div><%=mTime.substring(10,19)%>.0 <%=session_user_nm%></div></td>
		</tr> 
		<%	
			count++;
		%>
		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     			<input type="checkbox" name="ch_cd" value="doc1">
     		</td>
		    
			<td align="center">�Ƹ���ī</td>
     		<td align="center">��������</td>
			<td align="center">
				<a href="javascript:doc_cert_print()"><img src='/acar/images/center/button_in_print.gif' border=0></a>
			<!-- 	&nbsp;
				<a href="javascript:addr_ask_appl_reg()"><img src='/acar/images/center/button_in_reg.gif' border=0></a> -->
			</td>
			<td align="center"><div><%=mTime.substring(0,10)%></div><div><%=mTime.substring(10,19)%>.0 <%=session_user_nm%></div></td>
		</tr> 
		<%	
			count++;
		%>
		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     			<input type="checkbox" name="ch_cd" value="doc2">
     		</td>
		    
			<td align="center">�Ƹ���ī</td>
     		<td align="center">������</td>
			<td align="center">
				<a href="javascript:war_cert_print()"><img src='/acar/images/center/button_in_print.gif' border=0></a>
			<!-- 	&nbsp;
				<a href="javascript:addr_ask_appl_reg()"><img src='/acar/images/center/button_in_reg.gif' border=0></a> -->
			</td>
			<td align="center"><div><%=mTime.substring(0,10)%></div><div><%=mTime.substring(10,19)%>.0 <%=session_user_nm%></div></td>
		</tr> 
		<%	
			count++;
		%>
		
		<%
		if(ch_r.length > 0){
			for(int i=0; i<ch_r.length; i++){
				ch_bean = ch_r[i];
				content_code = "CAR_CHANGE";
				content_seq  = c_id+""+ch_bean.getCha_seq();

				Vector car_attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int car_attach_vt_size = car_attach_vt.size();
				
				if(car_attach_vt_size > 0){
					for (int j = 0 ; j < car_attach_vt_size ; j++){
						Hashtable attach_ht = (Hashtable)car_attach_vt.elementAt(j);
		%>		
			<tr>
			    <td align="center"><%= count+1 %></td>
		    		<td width='30' align='center'><input type="checkbox" name="ch_cd" value="<%=String.valueOf(attach_ht.get("SEQ"))%>"> </td>
			    
				<td align="center">�Ƹ���ī</td>
		    		<td align="center">�ڵ��� �����</td>
				<td align="center"><a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a></td>
				<td align="center"><%=attach_ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(attach_ht.get("REG_USERSEQ")),"USER")%></td>
			</tr>
		<%				count++;
					}
				}
			}
		}
       	%>
		
		
		<%
       	if(conProof_size > 0){
				for (int i = 0 ; i < conProof_size ; i++){
					Hashtable ht2 = (Hashtable)conProof.elementAt(i);
		%>
			<tr>
			    <td align="center"><%= count+1 %></td>
		    		<td width='30' align='center'><%-- <input type="checkbox" name="ch_cd" value="<%=String.valueOf(ht2.get("SEQ"))%>"> --%></td>
			    
				<td align="center">�Ƹ���ī</td>
		    		<td align="center">��������߼۳���</td>
				<td align="center"><a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='����' ><%=ht2.get("FILE_NAME")%></a></td>
				<td align="center"><%=ht2.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht2.get("REG_USERSEQ")),"USER")%></td>
			</tr>
		<%	
			count++;
			}
		}
       	%>
	  
	  
	  <% if(attach_vt_size > 0){
			for (int j = 0 ; j < attach_vt_size ; j++){
				Hashtable ht = (Hashtable)attach_vt.elementAt(j);
				
				if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 20){
						rent_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(19,20);
						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 						
						contentNm = c_db.getNameByIdCode("0028", "", file_st);	
				}
	
			if(!contentNm.equals("")){
				if(contentNm.contains("�뿩") || contentNm.contains("����ڵ����")){
	%>                
		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     		<%if(!String.valueOf(ht.get("FILE_TYPE")).equals("application/pdf")){ %>
     			<input type="checkbox" name="ch_cd" value="<%=String.valueOf(ht.get("SEQ"))%>">
     		<%} %>
     		</td>
			<td align="center">
			<%if(rent_st.equals("1") || rent_st.equals("")){%>	
				�ű�
			<%}else{%>		
				<%=AddUtil.parseInt(rent_st)-1%>������<%}%>
			</td>		
     		<td align="center"><%=contentNm%></td>
			<td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
			<td align="center"><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
		</tr>
		<%
			count++;
				}
			}		
		}
	  }
	  %>
<%-- 	  <%
	  	if(attach_vt_size ==0 && amazon_attach_vt_size == 0){%>
		<tr>
		    <td colspan="6" class=""><div align="center">�ش� ��ĵ������ �����ϴ�.</div></td>
		</tr>
		<%}%> --%>
		</table>
    </tr>
 </table>
 <div style="font-size:10pt;">* ��û�� �ź����� ���� �����Ͽ� ÷���Ͻñ� �ٶ��ϴ�.</div>
 <div style="font-size:10pt;">* PDF������ ������ ����Ͻñ� �ٶ��ϴ�.</div>
 <div style="text-align:center;margin-top:40px;">
 	<a href="javascript:Accid_ReqDoc_Print()"><img src='/acar/images/button_print.gif' border=0></a>
</div>
</form>
</body>
</html>
