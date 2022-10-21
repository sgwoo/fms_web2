<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.insur.*,acar.car_register.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	var popObj = null;
	
	//�˾������� ����
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}	
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');			
		}else{
			popObj = window.open(theURL,'popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		popObj.location = theURL;
		popObj.focus();			
	}	
	
	function view_car_exp(car_mng_id){
		window.open('view_exp_car_list.jsp?car_mng_id='+car_mng_id, "VIEW_EXP_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");
	}

	//��ĵ�� ����� ����
	function view_scanfile(path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/carReg/"+path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}		
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//��������
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//������ȣ �̷�
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
	
	//�ڵ����� �̷�
	Vector vt = ai_db.getExpCarList(car_mng_id);
	int vt_size = vt.size();
	
	//�Ű�����
	sBean = olsD.getSui(car_mng_id);
%>
<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=14%>���ʵ����</td>
                    <td width=20%>&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                    <td class=title width=13%>����</td>
                    <td width=20%>&nbsp;<%=c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext())%></td>
                    <td class=title width=13%>������ȣ</td>
                    <td width=20%>&nbsp;<%=cr_bean.getCar_doc_no()%></td>			
                </tr>
                <tr> 
                    <td class=title>�ڵ�����Ϲ�ȣ</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class=title>����</td>
                    <td>&nbsp; 
                      <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>                         
                    </td>
                    <td class=title>�뵵</td>
                    <td>&nbsp; 
                      <select name="car_use" disabled>
                        <option value="1" <%if(cr_bean.getCar_use().equals("1"))%> selected<%%>>������</option>
                        <option value="2" <%if(cr_bean.getCar_use().equals("2"))%> selected<%%>>�ڰ���</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=cr_bean.getCar_nm()%>
                    </td>
                    <td class=title>��ⷮ</td>
                    <td>&nbsp;<%=cr_bean.getDpm()%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%=cr_bean.getTaking_p()%></td>
                </tr>
                <tr> 
                    <td class=title>������</td>
                    <td>&nbsp;
        			  <%if(cr_bean.getPrepare().equals("")){%>��������<%}%>
        			  <%if(cr_bean.getPrepare().equals("1")){%>��������<%}%>
        			  <%if(cr_bean.getPrepare().equals("2")){%>�Ű�����<%}%>
        			  <%if(cr_bean.getPrepare().equals("3")){%>��������<%}%>
        			  <%if(cr_bean.getPrepare().equals("4")){%>��������<%}%>
        			  <%if(cr_bean.getPrepare().equals("5")){%>��������<%}%>
        			  <%if(cr_bean.getPrepare().equals("6")){%>�������<%}%>
        			  <%if(cr_bean.getPrepare().equals("7")){%>�縮������<%}%>
        			  <%if(cr_bean.getPrepare().equals("8")){%>��������<%}%>
                    </td>
                    <td class=title>��������</td>
                    <td colspan="3">&nbsp;
        			  <%if(cr_bean.getOff_ls().equals("")){%>��������<%}%>
        			  <%if(cr_bean.getOff_ls().equals("1")){%>�Ű�����<%}%>
        			  <%if(cr_bean.getOff_ls().equals("2")){%>�Ҹ�<%}%>
        			  <%if(cr_bean.getOff_ls().equals("3")){%>��ǰ����<%}%>
        			  <%if(cr_bean.getOff_ls().equals("4")){%>����<%}%>
        			  <%if(cr_bean.getOff_ls().equals("5")){%>��������<%}%>
        			  <%if(cr_bean.getOff_ls().equals("6")){%>�Ű�����<%}%>			  
        			</td>
                </tr>
            </table>  
	    </td>
	</tr>
	<tr>
	    <td></td>
	</tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ȣ �̷�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td class=title width=15%>��������</td>
                    <td class=title width=15%>�ڵ���������ȣ</td>
                    <td class=title width=15%>����</td>
                    <td class=title width=30%>�󼼳���</td>
                    <td class=title width=15%>�������ĵ</td>			
                </tr>
          <%if(ch_r.length > 0){
				for(int i=0; i<ch_r.length; i++){
			        ch_bean = ch_r[i];	%>
                <tr> 
                    <td align="center"><%=ch_bean.getCha_seq()%></td>
                    <td align="center"><%=ch_bean.getCha_dt()%></td>
                    <td align="center"><%=ch_bean.getCha_car_no()%></td>
                    <td align="center"> 
                      <% if(ch_bean.getCha_cau().equals("1")){%>
                      ��뺻���� ���� 
                      <%}else if(ch_bean.getCha_cau().equals("2")){%>
                      �뵵���� 
                      <%}else if(ch_bean.getCha_cau().equals("3")){%>
                      ��Ÿ 
                      <%}else if(ch_bean.getCha_cau().equals("4")){%>
                      ����
                      <%}else if(ch_bean.getCha_cau().equals("5"))%>�űԵ��<%%>			  
        			  </td>
                    <td bgcolor="#FFFFFF">&nbsp;<%=ch_bean.getCha_cau_sub()%></td>
                    <td align="center" >&nbsp;
                    <%if(!ch_bean.getScanfile().equals("")){%>					
					<%		if(ch_bean.getFile_type().equals("")){%>
    			    <a href="javascript:view_scanfile('<%=ch_bean.getScanfile()%>');"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%		}else{%>
    			    <a href="javascript:ScanOpen('<%= ch_bean.getScanfile() %>','<%= ch_bean.getFile_type() %>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> 					
					<%		}%>
        			<%} %>
        			</td>			
                </tr>
          <%	}
			}else{%>
                <tr> 
                    <td colspan=5 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>	
	<%if(!sBean.getCar_mng_id().equals("")){%>
	<tr>
	    <td></td>
	</tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ű�����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>		
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr>
                    <td width="16%" class=title>�Ÿ�����</td>
                    <td width="32%">&nbsp;<%=sBean.getCont_dt()%></td>
                    <td width="16%" class=title>����������</td>
                    <td>&nbsp;<%=sBean.getMigr_dt()%></td>
                </tr>	
                <tr>
                    <td width="16%" class=title>�����</td>
                    <td width="32%">&nbsp;<%=sBean.getSui_nm()%></td>
                    <td width="16%" class=title>�ŸŰ�</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(sBean.getMm_pr())%>��</td>
                </tr>	
                <tr>
                    <td width="16%" class=title>����������</td>
                    <td width="32%">&nbsp;<%=sBean.getCar_nm()%> (<%=sBean.getCar_relation()%>)</td>
                    <td width="16%" class=title>�����Ĺ�ȣ</td>
                    <td>&nbsp;<%=sBean.getMigr_no()%></td>
                </tr>	
            </table>		
        </td>
    </tr>			
	<%}%>
	<tr>
	    <td></td>
	</tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ����� �̷�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center"> 
        		    <td width='30' rowspan="2" class=title>����</td>
        		    <td colspan="5" class=title>����</td>
        		    <td colspan="5" class=title >ȯ��</td>
	            </tr>
		        <tr valign="middle" align="center">
        		    <td width='120' class=title>�Ⱓ</td>		  
        		    <td width='80' class=title>�ݾ�</td>		  
        		    <td width='80' class=title>������</td>		  			
        		    <td width="80" class=title>����</td>
        		    <td width="80" class=title>������ȣ</td>
        		    <td width='80' class=title>����</td>		  
        		    <td width='80' class=title>�����߻���</td>		  
        		    <td width='80' class=title>��û��</td>
        		    <td width='80' class=title>�ݾ�</td>
        		    <td width='80' class=title>�Ա���</td>						
		        </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		        <tr> 
        		    <td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("EXP_START_DT")%>~<%=ht.get("EXP_END_DT")%></td>
        		    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("EXP_AMT")))%>��&nbsp;</td>
        		    <td align='center'><%=ht.get("EXP_DT")%></td>			
        		    <td align='center'><%=ht.get("CAR_EXT_NM")%></td>
        		    <td align='center'><%=ht.get("CAR_NO")%></td>			
        		    <td align='center'><%=ht.get("RTN_CAU_NM")%></td>
        		    <td align='center'><%=ht.get("RTN_CAU_DT")%></td>
        		    <td align='center'><%=ht.get("RTN_REQ_DT")%></td>			
        		    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("RTN_AMT")))%>��&nbsp;</td>
        		    <td align='center'><%=ht.get("RTN_DT")%></td>
		        </tr>
  <%		total_amt = total_amt + Long.parseLong(String.valueOf(ht.get("EXP_AMT")));
		  	total_amt2 = total_amt2 + Long.parseLong(String.valueOf(ht.get("RTN_AMT")));
		  }%>
				<tr>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>										
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>															
					<td class="title">&nbsp;</td>															
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>��&nbsp;</td>
					<td class="title">&nbsp;</td>					
				</tr>		  
	        </table>
	    </td>
	</tr>	
	<tr>
		<td align='right'>
		  <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></a>
		</td>	
	</tr>	
</table>
</form>  
</body>
</html>
