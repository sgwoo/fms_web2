<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" scope="page" class="acar.forfeit_mng.FineDocBean"/>
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
	
		//�����û����Ʈ
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    long t_amt4[] = new long[1];
 //   long t_amt5[] = new long[1];
    long t_amt6[] = new long[1];
    long t_amt7[] = new long[1];
    long t_amt8[] = new long[1];
    long t_amt9[] = new long[1];
    
    long t_amt10[] = new long[1];   //������ 
    
    String gov_chk_id = "";
    
    
    long r_amt = 0;
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 20.0; //��ܿ���    
		factory.printing.bottomMargin 	= 30.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}

	
	//�ϰ��μ�
	function select_doc_print(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch3_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("�μ��� ����� �����ϼ���.");
			return;
		}	
		
		window.open('about:blank', "BANK_MNG_PRINT", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "BANK_MNG_PRINT";		
		fm.action = "reg_ms.jsp";
		fm.submit();	
	}
	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch3_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}		
</script>
</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<form action="" name="form1" method="POST" >
  <input type='hidden' name='ck_acar_id' 	value='<%=ck_acar_id%>'>
  <table width='1500' border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="100%" height="30" align="left" style="font-size : 10pt;"><font face="����"># ÷��: ���� ������ ( <%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%> ) </font></td>
    </tr>
	<%//if(ck_acar_id.equals("000096")||ck_acar_id.equals("000172")||ck_acar_id.equals("000004")){%>
	<tr> 
      <td height="10" align=""><a href="javascript:select_doc_print();">[�ϰ��μ�]</a></td>
    </tr>
	<%//}%>
    <tr> 
      <td height="10" align="center"></td>
    </tr>	
    <tr bgcolor="#000000"> 
      <td align='center'> 
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr  bgcolor="#000000"> 
            <td> 
			  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr bgcolor="#FFFFFF" align="center">
                  <td height="30" width="3%"  rowspan="3" style="font-size : 10pt;"><font face="����">����</font><br><%//if(ck_acar_id.equals("000096")||ck_acar_id.equals("000172")||ck_acar_id.equals("000004")){%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"><%//}%></td>
                  <td height="30" width="36%" colspan="6" style="font-size : 10pt;"><font face="����">�ڵ����뿩��೻��</font></td>
                  <td height="30" width="41%"  colspan="6" style="font-size : 10pt;"><font face="����">�ڵ������Գ���</font></td>
                  <td height="30" width="21%" colspan="4" style="font-size : 10pt;"><font face="����">������޳���</font></td>
                </tr>
                <tr bgcolor="#FFFFFF" align="center">
                  <td height="25" colspan="2" style="font-size : 10pt;"><font face="����">������</font></td>
                  <td height="25" colspan="3" style="font-size : 10pt;" ><font face="����">������</font></td>
                  <td height="25" width="6%" rowspan="2" style="font-size : 10pt;"  ><font face="����">������/<br>������</font></td>
                  <td height="25" colspan="3" style="font-size : 10pt;"><font face="����">�ڵ�������</font></td>
                  <td height="25" colspan="3" style="font-size : 10pt;"><font face="����">���Ը�</font></td>
                  <td height="25" colspan="2" style="font-size : 10pt;"><font face="����">�����</font></td>
                  <td height="25" colspan="2" style="font-size : 10pt;"><font face="����">�㺸</font></td> 
                </tr>
                <tr bgcolor="#FFFFFF" align="center">
                  <td width="9%" height="25" style="font-size : 10pt;"><font face="����">��ȣ/����</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="����">����ڹ�ȣ</font></td>
                  <td width="4%" height="25" style="font-size : 10pt;"><font face="����">���Ⱓ(��)</font></td>
                  <td width="5%" height="25" style="font-size : 10pt;"><font face="����">���뿩��</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="����">�Ѵ뿩��</font></td>
                  
                  <td width="9%" height="25" style="font-size : 10pt;"><font face="����">����</font></td>
                  <td width="5%" height="25" style="font-size : 10pt;"><font face="����">������ȣ</font></td>
                  <td width="9%" height="25" style="font-size : 10pt;"><font face="����">�����ȣ</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="����">���԰���</font></td>   
                  <td width="5%" height="25" style="font-size : 10pt;"><font face="����">������</font></td>                                    
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="����"><% if  ( FineDocBn.getGov_id().equals("0037") ||  FineDocBn.getGov_id().equals("0029") ) {%>����� <% } else {%>������� <% } %> </font></td>                    
                
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="����">����</font></td>
           <!--        <td width="5%" height="25" style="font-size : 10pt;"><font face="����">��漼</font></td> 
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="����">������</font></td> -->
                  <td width="5%" height="25" style="font-size : 10pt;"><font face="����">��޿�û��</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="����">�����ݾ�</font></td>
                  <td width="4%" height="25" style="font-size : 10pt;"><font face="����">����</font></td>
                </tr>
             
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="2" align="center"></td>
    </tr>	
    <tr bgcolor="#000000">
     <td width="100%" height="10" align='center'><table width="100%" border="0" cellspacing="1" cellpadding="0">
          <% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					Hashtable ht = (Hashtable)FineList.elementAt(i);
					
					gov_chk_id = String.valueOf(ht.get("GOV_ID"));
					
					
					r_amt =  AddUtil.parseLong(String.valueOf(ht.get("AMT3"))) - AddUtil.parseLong(String.valueOf(ht.get("SD_AMT"))) ;
				
					for(int j=0; j<1; j++){
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT1"))); //�뿩��
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT2"))); //�Ѵ뿩��
						t_amt3[j] += r_amt;	//���Ű��� - Ź�۰��� 
						t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT4")));	//����ݾ�
			//			t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("CAR_F_AMT")));	//�Һ��ڰ���
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("PRE_AMT")));	//�����ݾ�
						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT5")));	//��漼
						t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT6")));	//�㺸�� ����� �ݾ�
					//	t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("DAM_AMT")));	//�Ｚ�㺸�� ����� �ݾ�
						t_amt10[j] += AddUtil.parseLong(String.valueOf(ht.get("ECAR_AMT")));	//������   
					
						
					//	t_amt9[j] +=1000000;	//���� �㺸�� ����� �ݾ�
					}			
					
		%>
          <tr bgcolor="#FFFFFF" align="center">
            <td  width="3%" height="30" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="����"><%//if(ck_acar_id.equals("000096")||ck_acar_id.equals("000172")||ck_acar_id.equals("000004")){%><input type="checkbox" name="ch3_cd" value="<%=ht.get("RENT_L_CD")%><%=ht.get("RENT_MNG_ID")%><%=ht.get("DOC_ID")%>"><%//}%><%=i+1%></font></td>
            <td  width="9%" style="font-size : 8pt;"><font face="����"><%=ht.get("FIRM_NM")%></font></td>
            <td  width="6%" style="font-size : 8pt;"><font face="����"><%=ht.get("ENP_NO")%></font></td>
            <td  width="4%" style="font-size : 8pt;"><font face="����"><%=ht.get("PAID_NO")%></font></td>
            <td  width="5%" style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(ht.get("AMT1"))%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(ht.get("AMT2"))%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(ht.get("PRE_AMT"))%></font></td>
            <td  width="9%" style="font-size : 8pt;"><font face="����"><%=ht.get("CAR_NM")%></font></td>
            <td  width="5%" style="font-size : 8pt;"><font face="����"><%=ht.get("CAR_NO")%></font></td>  
            <td  width="9%" style="font-size : 8pt;"><font face="����"><%=ht.get("CAR_NUM")%></font></td>       
            <td  width="6%" style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(r_amt)%></font></td>
            <td  width="5%" style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(ht.get("ECAR_AMT"))%></font></td> <!--������  -->
            <td  width="6%" style="font-size : 8pt;"><font face="����"><% if  ( FineDocBn.getGov_id().equals("0037")  || FineDocBn.getGov_id().equals("0029")  ) {%><%=ht.get("DLV_DT") %><% } else {%><%=ht.get("DLV_EST_DT")%> <% } %></font></td>            
          
            <td  width="6%" style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(ht.get("AMT4"))%></font></td>
       <!--      <td  width="5%" style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(ht.get("AMT5"))%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT4"))) +  AddUtil.parseLong(String.valueOf(ht.get("AMT5"))))%></font></td> -->
            <td  width="5%" style="font-size : 8pt;"><font face="����"><%=ht.get("END_DT")%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(ht.get("AMT6"))%>
            <!-- �Ｚī��� 20% �㺸 -->
 <!--         <% if ( gov_chk_id.equals("0018") ) {%>
            <%=Util.parseDecimal(ht.get("DAM_AMT"))%>
            <% } else if (  gov_chk_id.equals("0044")   ||   gov_chk_id.equals("0059")   )   { %>   
           <%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT4")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT5"))))%>     
           <% } else if (  gov_chk_id.equals("0058")     )   { %>   
           <%=Util.parseDecimal(1000000)%>     
             <% } else { %>   
            <%=Util.parseDecimal((AddUtil.parseLong(String.valueOf(ht.get("AMT4")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT5"))))/2)%>
            <% } %> -->
            </font></td>
            
            <td  width="4%" style="font-size : 8pt;"><font face="����"></font></td>
          
          </tr>
          <% 	} %>
         <tr bgcolor="#FFFFFF" align="center">
            <td  colspan=4 height="30"  bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="����">�հ�</font></td>
            <td  style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(t_amt1[0])%></font></td>
            <td  style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(t_amt2[0])%></font></td>
            <td  style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(t_amt6[0])%></font></td>
            <td  colspan=3 style="font-size : 8pt;"><font face="����"></font></td>
            <td  style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(t_amt3[0])%></font></td>
            <td  style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(t_amt10[0])%></font></td>
            <td  style="font-size : 8pt;"><font face="����"></font></td> <!-- ������� -->
            <td  style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(t_amt4[0])%></font></td>
          <!--   <td  style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(t_amt7[0])%></font></td>
            <td  style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(t_amt4[0]+t_amt7[0])%></font></td> -->
            <td  style="font-size : 8pt;"><font face="����"></font></td>
            <td  style="font-size : 8pt;" align=right><font face="����"><%=Util.parseDecimal(t_amt8[0])%>
     <!--       <% if ( gov_chk_id.equals("0018") ) {%>
            <%=Util.parseDecimal(t_amt8[0])%>
             <% } else if (gov_chk_id.equals("0044") ||  gov_chk_id.equals("0059")    )   { %>   
            <%=Util.parseDecimal((t_amt4[0]+t_amt7[0]) )%>
             <% } else if (gov_chk_id.equals("0058")    )   { %>   
            <%=Util.parseDecimal(t_amt9[0] )%> 
            <% } else { %>   
            <%=Util.parseDecimal((t_amt4[0]+t_amt7[0])/2 )%>
            <% } %>  --> 
            </font></td>
            <td  style="font-size : 8pt;"><font face="����"></font></td>
          </tr>
		<%} %>
      </table></td>
    </tr>
    <tr> 
      <td height="5" align="center"></td>
    </tr>	
    <tr> 
      <td height="25" style="font-size : 10pt;"><font face="����">*&nbsp;
      <!--
      <% if ( gov_chk_id.equals("0018") ||  gov_chk_id.equals("0041")   ||  gov_chk_id.equals("0011")  ||  gov_chk_id.equals("0055")  ||  gov_chk_id.equals("0069")   ||  gov_chk_id.equals("0072")     ) {%>
 ����ݾ��� 20% ������ ���� 
      <% } else if ( gov_chk_id.equals("0044") ||  gov_chk_id.equals("0059")     )   { %>
      ����ݾ��� 100% ������ ���� 
        <% } else if ( gov_chk_id.equals("0058")  ||  gov_chk_id.equals("0037")  ||  gov_chk_id.equals("0011")     ||  gov_chk_id.equals("0029")   ||  gov_chk_id.equals("0033")      )   { %>
     
      <% } else { %>
      ����ݾ��� 50% ������ ����
      <% } %>
-->      
      </font></td>
    </tr>	
  </table>
 
</form>
</body>
</html>
