<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*, acar.car_register.*, acar.cooperation.* "%>
<%@ page import="acar.accid.*, acar.res_search.*, acar.cont.*, acar.short_fee_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" 	class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" 	class="acar.fee.AddFeeDatabase"	/>
<jsp:useBean id="al_db" scope="page" 	class="acar.client.AddClientDatabase"/>
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
function addr_ask_appl_print(){
	var fm = document.form1;	
	 window.open("" ,"form1", 
     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
	fm.action = "addr_ask_appl_print.jsp";
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
		fm.action = "cooperation_u3_print.jsp";
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ä�ǰ��� > <span class=style1>ä�����ּ���ȸ��û ><span class=style5>��ĵ����</span></span></td>
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
		    <td class="title" width='7%'>���</td>
		    <td class="title" width='30%'>����</td>                    
		    <td class="title" width='30%'>���Ϻ���</td>
		    <td class="title" width='20%'>�����</td>
		</tr>
		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     			<input type="checkbox" name="ch_cd" value="doc1">
     		</td>
		    
			<td align="center">�ű�</td>
     		<td align="center">ä�����ּ���ȸ</td>
			<td align="center">
				<a href="javascript:addr_ask_appl_print()"><img src='/acar/images/center/button_in_print.gif' border=0></a>
			<!-- 	&nbsp;
				<a href="javascript:addr_ask_appl_reg()"><img src='/acar/images/center/button_in_reg.gif' border=0></a> -->
			</td>
			<td align="center">��ϵ��� ����</td>
		</tr>
				
		<%	
			count++;
		
       	if(conProof_size > 0){
				for (int i = 0 ; i < conProof_size ; i++){
					Hashtable ht2 = (Hashtable)conProof.elementAt(i);
		%>
			<tr>
			    <td align="center"><%= count+1 %></td>
		    		<td width='30' align='center'><%-- <input type="checkbox" name="ch_cd" value="<%=String.valueOf(ht2.get("SEQ"))%>"> --%></td>
			    
				<td align="center">�ű�</td>
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
				if(contentNm.contains("��༭") || contentNm.contains("����ڵ����") || contentNm.contains("�ΰ�����")){
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
		
	  }else{ %>
		<tr>
		    <td colspan="6" class=""><div align="center">�ش� ��ĵ������ �����ϴ�.</div></td>
		</tr>
		<% 	} %>
		</table>
    </tr>
 </table>
 <div style="text-align:center;margin-top:40px;">
 	<a href="javascript:Accid_ReqDoc_Print()"><img src='/acar/images/button_print.gif' border=0></a>
</div>
</form>
</body>
</html>
