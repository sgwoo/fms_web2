<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>
<jsp:useBean id="se_bean" class="acar.offls_actn.Offls_sui_etcBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="mbean" class="acar.asset.AssetMaBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	//�ڵ������� �˻� ������
	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "13", "06");	
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	
	int alt_amt = 0;
			
	AssetDatabase as_db = AssetDatabase.getInstance();
	
	AssetMoveBean rl_r [] = as_db.getAssetSaleListAll(st_dt,end_dt,s_kd,t_wd,sort,asc, gubun2);  //���Կɼ� ���� 
//	AssetMoveBean rl_r [] = as_db.getAssetSaleListAll(st_dt,end_dt,s_kd,t_wd,sort,asc,"3" ); //���� ��������ǥ�����ϱ� ���� �ӽ� ���
	
	long comm_tot = 0;
	long tot1 = 0;
	long tot2 = 0;
	long tot3 = 0;
	long tot4 = 0;
	long tot5 = 0;
	long tot6 = 0;
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//����ϱ�
	function save(car_mng_id, asset_code, assch_seri, chk, acct_code, ven_code, client_id2, assch_date, gisu){
		
		var fm = document.form1;
		fm.car_mng_id.value = car_mng_id;
		fm.asset_code.value = asset_code;
		fm.assch_seri.value = assch_seri;
		fm.assch_date.value = assch_date;
		fm.gisu.value = gisu;

		fm.acct_code.value = acct_code;
		fm.ven_code.value = ven_code;
		fm.client_id2.value = client_id2;
		fm.chk.value = chk;
		
		if ( fm.client_id2.value == "" ) {
			 alert('�ŸŻ��� Ȯ���ϼ���!!');
		     return;
		}	
						
		//��¥ check		
		 if ( toInt(replaceString("-","",fm.assch_date.value)) >  toInt(replaceString("-","",fm.today_dt.value))) { //�Ű����� ���Ϻ��� ū��� ��꼭 ���� �ȵ� 
			alert('�Ű����� ���ú��� Ŭ ���� �����ϴ�.');
			return;
		} 	
			
	// �� �̿��� ���� ��������ǥó������
		 if ( fm.chk.value == '1' ) {
		  } else {
			  	
			// �ڻ�ó�� ��� Ȯ��.
			//�����ϰ� ����� Ʋ����� üũ  s_str.substring(0,4)
			if ( fm.assch_date.value.substring(0,4)  != fm.gisu.value  ) {
				alert('�ش� ��� �ڻ����θ� �ڻ�ó���� �� �ֽ��ϴ�.');
				return;
			}
			  
			// �ڻ�ó�� ��� Ȯ��.
			/*
				if ( toInt(replaceString("-","",fm.assch_date.value)) > 20201231	) {	
					alert('2020�����θ� �ڻ�ó���� �� �ֽ��ϴ�.');
					return;
				}		
						
				if ( toInt(replaceString("-","",fm.assch_date.value)) <= 20191231	) {
					alert('2020�����θ� �ڻ�ó���� �� �ֽ��ϴ�.');
					return;
				} */	
		}
	
		if ( fm.auth_rw.value =='1' ) {
		  	alert('������ �����ϴ�.');		
			return;		 
		} else {
		
			if(!confirm("�ڵ���ǥ�� �����Ͻðڽ��ϱ�?"))	return;
						
			fm.action = 'asset_sale_reg_autodoc_a.jsp';
			fm.target="i_no";		
			fm.submit();
		}
	}
	
	//����ϱ�
	function save1(car_mng_id, asset_code, assch_seri, chk, acct_code, ven_code, client_id2, assch_date, gisu){
				
		var fm = document.form1;
		fm.car_mng_id.value = car_mng_id;
		fm.asset_code.value = asset_code;
		fm.assch_seri.value = assch_seri;
		fm.acct_code.value = acct_code;
		fm.assch_date.value = assch_date;
		fm.gisu.value = gisu;
		
		fm.ven_code.value = ven_code;
		fm.client_id2.value = client_id2;
		fm.chk.value = chk;
		
		// �� �̿��� ���� ��������ǥó������
		 if ( fm.chk.value == '1' ) {
		 } else {							 

			// �ڻ�ó�� ��� Ȯ��.
				//�����ϰ� ����� Ʋ����� üũ  s_str.substring(0,4)
				if ( fm.assch_date.value.substring(0,4)  != fm.gisu.value  ) {
					alert('�ش� ��� �ڻ����θ� �ڻ�ó���� �� �ֽ��ϴ�.');
					return;
				}
			
				// �ڻ�ó�� ��� Ȯ��.
			/*	if ( toInt(replaceString("-","",fm.assch_date.value)) > 20201231	) {	
					alert('2020�����θ� �ڻ�ó���� �� �ֽ��ϴ�.');
					return;
				}		
						
				if ( toInt(replaceString("-","",fm.assch_date.value)) <= 20191231	) {
					alert('2020�����θ� �ڻ�ó���� �� �ֽ��ϴ�.');
					return;
				}	
				*/
		}
				
		if ( fm.auth_rw.value =='1' ) {
		  	alert('������ �����ϴ�.');		
			return;		 
		} else {
										
			if(!confirm("�ڵ���ǥ�� ������Ͻðڽ��ϱ�?"))	return;
						
			fm.action = 'asset_sale_reg_autodoc1_a.jsp';
			fm.target="i_no";		
			fm.submit();
		}
	}
	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form  name="form1" method="POST">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="100%">  
                <tr><td class=line2></td></tr>          	
            	<tr>
            		<td class=line>
            			<table border=0 cellspacing=1 width=100%>						
                            <tr> 
                                <td width=4% class=title rowspan="2">����</td>
                                <td width=9% class=title rowspan="2">������ȣ</td>
                                <td width=18% class=title rowspan="2">�ڻ��</td>
                                <td width=8% class=title rowspan="2">�����(�ֹ�)</td>
                                <td width=8% class=title rowspan="2">��꼭����</td>
                                <td width=8% class=title rowspan="2">�Ű���</td>
                				<td width=7% class=title rowspan="2">�����ݾ�</td>
								<td width=24% class=title colspan="4">�Ű� ������</td>
                				<td width=4% class=title rowspan="2">��������ǥ</td>
                				<td width=6% class=title rowspan="2">�Ű���ǥ</td>
                				<td width=4% class=title rowspan="2">����</td>
            		        </tr>
							<tr>
					<td class='title' width=6%>����<br>������</td>
				          <td class='title' width=6%>��ǰ<br>������</td>		                         
		                              <td width=6% class='title'>����Ź��<br>����Ա�</td>
					  <td width=6% class='title'>�հ�</td>
							</tr>
                          <%if(rl_r.length != 0){ %>
                          <% 	for(int i=0; i<rl_r.length; i++){
                          			
                    				AssetMoveBean bean = rl_r[i];
									
									se_bean = as_db.getInfoComm(bean.getCar_mng_id());
									comm_tot = se_bean.getComm1_tot()+se_bean.getComm2_tot()+se_bean.getComm3_tot();
									
									tot1 += bean.getSale_amt();
									tot5 += comm_tot;
									tot2 += se_bean.getComm1_tot();
									tot3 += se_bean.getComm2_tot();
									tot4 += se_bean.getComm3_tot();
									tot6 += se_bean.getComm4_tot();
									
									//asset_code�� ��� 
									 mbean = as_db.getAssetMa(bean.getAsset_code());
                    	  %>
                            <tr> 
                                <td align="center"><%=i+1%></td>
                                <td align="center"><%= bean.getCar_no() %></td>
                                <td align="left">
                                    <table border=0 cellspacing=1 width=98% cellpadding=1>						
                                        <tr> 
                                            <td><%= bean.getAsset_name() %></td>
                                        </tr>
                                    </table>
                                </td>
                                <td align="center">&nbsp;<%= bean.getCar_nm() %></td>
                                <td align="center">&nbsp;<%= bean.getClient_tax() %></td>
                			    <td align="center"><%= AddUtil.ChangeDate2(bean.getAssch_date()) %>&nbsp;<%=ac_db.getCarSoldCnt(bean.getCar_mng_id())%> </td>
                                <td align="right"><%=Util.parseDecimal(bean.getSale_amt())%>&nbsp;</td>	
								<td align="right"><%=Util.parseDecimal(se_bean.getComm1_tot())%>&nbsp;</td>
								<td align="right"><%=Util.parseDecimal(se_bean.getComm2_tot())%>&nbsp;</td>
								<td align="right"><%=Util.parseDecimal(se_bean.getComm3_tot())%>&nbsp;</td>
								<td align="right"><%=Util.parseDecimal(comm_tot)%>&nbsp;</td>
                                <td align='center'>&nbsp; 
                               <% if ( auth_rw.equals("4") || auth_rw.equals("6") ) {%>                                
                	             <%if( bean.getComm_yn().equals("N") ){%>                	            
                	              <a href="javascript:save('<%=bean.getCar_mng_id()%>', '<%=bean.getAsset_code()%>', '<%= bean.getAssch_seri() %>', '1', '<%=bean.getAcct_code()%>', '<%=bean.getVen_code()%>', '<%=bean.getClient_id2()%>', '<%=bean.getAssch_date()%>' , ''  )" onMouseOver="window.status=''; return true" title='<%=Util.parseDecimal(comm_tot)%>'><img src=/acar/images/center/button_in_bh.gif align=absmiddle border=0></a> 
                	                 <%}else{%>
                	              -&nbsp;
                	               <a href="javascript:save1('<%=bean.getCar_mng_id()%>', '<%=bean.getAsset_code()%>', '<%= bean.getAssch_seri() %>', '1', '<%=bean.getAcct_code()%>', '<%=bean.getVen_code()%>', '<%=bean.getClient_id2()%>',  '<%=bean.getAssch_date()%>', '' )" onMouseOver="window.status=''; return true">�����</a> 
                	              <%}%>	
                	           <% } %>   							  
                	            </td>
                                <td align="center">&nbsp;
                                  <% if ( auth_rw.equals("4") || auth_rw.equals("6") ) {%>  
	                                   <%if( bean.getSale_yn().equals("N") ){%>
	                	           <a href="javascript:save('<%=bean.getCar_mng_id()%>', '<%=bean.getAsset_code()%>', '<%= bean.getAssch_seri() %>', '2', '<%=bean.getAcct_code()%>', '<%=bean.getVen_code()%>', '<%=bean.getClient_id2()%>'  , '<%=bean.getAssch_date()%>', '<%=mbean.getGisu()%>' )" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_bh.gif align=absmiddle border=0></a> 
	                	              <%}else{%>
	                	              -&nbsp;
	                	             <a href="javascript:save1('<%=bean.getCar_mng_id()%>', '<%=bean.getAsset_code()%>', '<%= bean.getAssch_seri() %>', '2', '<%=bean.getAcct_code()%>', '<%=bean.getVen_code()%>', '<%=bean.getClient_id2()%>',  '<%=bean.getAssch_date()%>', '<%=mbean.getGisu()%>' )" onMouseOver="window.status=''; return true">�����</a>                 	               
	                	              <%}%>
	                	          <% } %>       
                                </td>	
                			    <td align="center"><%= bean.getAcct_code() %></td>	
                          
                            </tr>
							
                          <%	}%>
							<tr>
								<td align="center" colspan="6">�հ�</td>
								<td align="right"><%=Util.parseDecimal(tot1)%>&nbsp;</td>
								<td align="right"><%=Util.parseDecimal(tot2)%>&nbsp;</td>
								<td align="right"><%=Util.parseDecimal(tot3)%>&nbsp;</td>
								<td align="right"><%=Util.parseDecimal(tot4)%>&nbsp;</td>
								<td align="right"><%=Util.parseDecimal(tot5)%>&nbsp;</td>
								<td colspan="3"></td>
							</tr>
                          <%}%>
							
            			  <%if(rl_r.length == 0){ %>			  
                            <tr> 
                                <td colspan="14" align="center">&nbsp;��ϵ� ����Ÿ�� �����ϴ�.</td>
                            </tr>
            			  <%}%>			  
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="asset_code" value="">
<input type="hidden" name="acct_code" value="">
<input type="hidden" name="ven_code" value="">
<input type="hidden" name="client_id2" value="">
<input type="hidden" name="assch_seri" value="">
<input type="hidden" name="assch_date" value="">
<input type="hidden" name="gisu" value="">
<input type="hidden" name="chk" value="">
<input type="hidden" name="cmd" value="">
<input type='hidden' name="today_dt" 	value="<%=AddUtil.getDate()%>">

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>

</body>
</html>


